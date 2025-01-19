defmodule PescarteWeb.Auth do
  @moduledoc """
  Módulo responsável por controlar tanto autenticação quanto
  autorização das "dead views" e live views, além de autenticação via API.
  """

  # apenas um hotfix, pra forçar esse módulo
  # ser compilado antes e portanto o bytecode vai existir
  # quando a macro abaixo for executada
  # isso deve ser resolvido na próxima release de `supabase_gotrue`
  require Pescarte.Supabase

  use Supabase.GoTrue.Plug,
    client: Pescarte.Supabase,
    endpoint: PescarteWeb.Endpoint,
    signed_in_path: "/app/pesquisa/perfil",
    not_authenticated_path: "/acessar"

  use Supabase.GoTrue.LiveView,
    client: Pescarte.Supabase,
    endpoint: PescarteWeb.Endpoint,
    signed_in_path: "/app/pesquisa/perfil",
    not_authenticated_path: "/acessar"

  import Plug.Conn

  alias Pescarte.Identidades.Models.Usuario
  alias Supabase.GoTrue
  alias Supabase.GoTrue.Session
  alias Supabase.GoTrue.User

  def require_admin_role(conn, _opts) do
    token = get_session(conn, :user_token)

    with {:ok, client} <- Pescarte.get_supabase_client(),
         {:ok, user} <- GoTrue.get_user(client, %Session{access_token: token}),
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
    socket = mount_current_user(session, socket)
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

  defp permit?(%User{role: role}, role), do: true

  defp permit?(_user, _role), do: false
end
