defmodule PescarteWeb.Authorization do
  import Plug.Conn

  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.Clients.Auth
  alias Supabase.GoTrue

  def require_admin_role(conn, _opts) do
    current_user = conn.assigns.current_user
    token = get_session(conn, :user_token)

    with {:ok, user} <- Auth.get_user(current_user.id),
         {:ok, usuario} <- Usuario.fetch_by(external_customer_id: user.id) do
      (token && usuario)
      |> permit?(:admin)
      |> maybe_halt(conn)
    else
      _ -> conn
    end
  end

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Não autorizado")
    |> Phoenix.Controller.redirect(to: "/app/pesquisa/perfil")
    |> halt()
  end

  def on_mount(:ensure_admin_role, _params, session, socket) do
    socket = GoTrue.LiveView.mount_current_user(session, socket)
    user = socket.assigns.current_user

    if user && permit?(user, :admin) do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "Não autorizado")
        |> Phoenix.LiveView.redirect(to: "/")

      {:halt, socket}
    end
  end

  defp permit?(%Usuario{papel: role}, role), do: true

  defp permit?(_user, _role), do: false
end
