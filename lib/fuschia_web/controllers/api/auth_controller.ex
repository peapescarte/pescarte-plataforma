defmodule FuschiaWeb.AuthController do
  @moduledoc """
  Handle Fuschia Authentication API
  """

  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.Accounts
  alias Fuschia.Context.AuthLogs
  alias FuschiaWeb.Auth.Guardian
  alias FuschiaWeb.{RemoteIp, UserAgent}
  alias FuschiaWeb.Swagger.{AuthSchemas, Response, Security, UserSchemas}

  action_fallback FuschiaWeb.FallbackController

  tags(["authentication"])
  security(Security.public())

  @doc """
  Parse headers before handling the route
  """
  @spec action(Plug.Conn.t(), map) :: Plug.Conn.t()
  def action(conn, _params) do
    ip = RemoteIp.get(conn)
    user_agent = UserAgent.get(conn)
    args = [conn, ip, user_agent, conn.params]

    apply(__MODULE__, action_name(conn), args)
  end

  @doc """
  Logs-in an user, requires an email and a matching password
  """
  operation(:login,
    request_body: {"The login attributes", "application/json", AuthSchemas.LoginRequest},
    responses:
      [
        ok:
          {"Successful JWT Token with User Claims Response", "application/json",
           AuthSchemas.LoginResponse}
      ] ++ Response.errors(:unauthorized)
  )

  @spec login(Plug.Conn.t(), String.t(), String.t(), map) :: Plug.Conn.t()
  def login(conn, ip, user_agent, params) do
    with {:ok, token} <- Guardian.authenticate(params),
         {:ok, user} <- Guardian.user_claims(params),
         :ok <- AuthLogs.create(ip, user_agent, user) do
      render_response(%{user: user, token: token}, conn)
    end
  end

  @doc """
  Signs-up an "avulso" user. Whichever value is passed to `perfil`, this function always creates as "avulso"
  """
  operation(:signup,
    request_body:
      {"The user attributes", "application/json", UserSchemas.UserSignupRequest, required: true},
    responses:
      [
        ok: {"Successful Signup with User Data", "application/json", UserSchemas.UserResponse}
      ] ++ Response.errors(:unauthorized)
  )

  @spec signup(Plug.Conn.t(), String.t(), String.t(), map) :: Plug.Conn.t()
  def signup(conn, _ip, _user_agent, params) do
    with {:ok, user} <- Accounts.register(params) do
      render_response(user, conn, :created)
    end
  end
end
