defmodule FuschiaWeb.Live.InitAssigns do
  @moduledoc """
  Adiciona campos comuns em todas as live views
  """

  import FuschiaWeb.Gettext
  import Phoenix.LiveView

  alias Fuschia.Accounts
  alias Fuschia.Accounts.Models.User
  alias FuschiaWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, session, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn ->
        find_current_user(session)
      end)
      |> attach_hook(:current_path, :handle_params, fn _params, url, socket ->
        {:cont, assign(socket, uri: URI.parse(url))}
      end)

    case socket.assigns.current_user do
      %User{} ->
        socket

      _other ->
        socket
        |> put_flash(:error, dgettext("errors", "You must log in to access this page."))
        |> redirect(to: Routes.user_session_path(socket, :new))
    end
  end

  defp find_current_user(session) do
    with session_token when is_binary(session_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(session_token),
         do: user
  end
end
