defmodule FuschiaWeb.LiveHelpers do
  @moduledoc """
  Funções comuns ao contexto LiveView,
  como autenticação por exemplo
  """

  import FuschiaWeb.Gettext
  import Phoenix.LiveView

  alias Fuschia.Accounts
  alias Fuschia.Accounts.User
  alias FuschiaWeb.Router.Helpers, as: Routes

  def assign_defaults(session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        find_current_user(session)
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
