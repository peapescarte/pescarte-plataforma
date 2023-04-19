defmodule PescarteWeb.Authorization do
  import Plug.Conn

  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.Accounts.Models.User
  alias PescarteWeb.Authentication

  def require_admin_role(conn, _opts) do
    token = get_session(conn, :user_token)

    (token && Accounts.get_user_by_session_token(token))
    |> permit?(:admin)
    |> maybe_halt(conn)
  end

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Não autorizado")
    |> Phoenix.Controller.redirect(to: Authentication.signed_in_path())
    |> halt()
  end

  def on_mount(:ensure_admin_role, _params, session, socket) do
    socket = Authentication.mount_current_user(session, socket)
    user = socket.assigns.current_user

    if user && permit?(user, :admin) do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "Não autorizado")
        |> Phoenix.LiveView.redirect(to: Authentication.signed_in_path())

      {:halt, socket}
    end
  end

  defp permit?(%User{role: role}, role), do: true

  defp permit?(_user, _role), do: false
end
