defmodule FuschiaWeb.AuthController do
  @moduledoc """
  Handle Fuschia Authentication API
  """

  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.Context.Users
  alias FuschiaWeb.Auth.Guardian
  alias FuschiaWeb.Swagger.{AuthSchemas, Response, Security, UserSchemas}

  action_fallback FuschiaWeb.FallbackController

  tags(["authentication"])
  security(Security.public())

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

  def login(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params),
         {:ok, user} <- Guardian.user_claims(params) do
      render_response(%{token: token, user: user}, conn)
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

  def signup(conn, params) do
    with {:ok, user} <- Users.register(params) do
      render_response(user, conn, :created)
    end
  end
end
