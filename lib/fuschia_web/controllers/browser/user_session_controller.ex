defmodule FuschiaWeb.UserSessionController do
  use FuschiaWeb, :controller

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias FuschiaWeb.{RemoteIp, UserAgent, UserAuth}

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

  def new(conn, _ip, _user_agent, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, ip, user_agent, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      with :ok <- Accounts.create_auth_log(ip, user_agent, user) do
        UserAuth.log_in_user(conn, user, user_params)
      end
    else
      # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
      render(conn, "new.html", error_message: dgettext("errors", "Invalid email or password"))
    end
  end

  def delete(conn, _ip, _user_agent, _params) do
    conn
    |> put_flash(:info, dgettext("infos", "Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
