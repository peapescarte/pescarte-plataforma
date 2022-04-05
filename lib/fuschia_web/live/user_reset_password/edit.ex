defmodule FuschiaWeb.UserResetPasswordLive.Edit do
  @moduledoc false

  use FuschiaWeb, :live_view

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, PasswordInput}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"token" => token}, _uri, socket) do
    {:noreply, get_user_by_reset_password_token(socket, token)}
  end

  # Não faça login do usuário após redefinir a senha para evitar uma
  # token vazado dando ao usuário acesso à conta.
  def handle_event("reset", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, dgettext("infos", "Password reset successfully."))
         |> redirect(to: Routes.user_session_path(socket, :new))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_user_by_reset_password_token(socket, token) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      changeset = Accounts.change_user_password(socket.assigns.user)

      socket
      |> assign(:user, user)
      |> assign(:token, token)
      |> assign(changeset: changeset)
    else
      socket
      |> put_flash(
        :error,
        dgettext("errors", "Reset password link is invalid or it has expired.")
      )
      |> redirect(to: "/")
    end
  end
end
