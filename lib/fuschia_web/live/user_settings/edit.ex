defmodule FuschiaWeb.UserSettingsLive.Edit do
  @moduledoc false

  use FuschiaWeb, :live_view

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias FuschiaWeb.UserAuth
  alias Surface.Components.Form
  alias Surface.Components.Form.{EmailInput, Field, Label, PasswordInput}

  def mount(_params, session, socket) do
    {:ok,
     session
     |> assign_defaults(socket)
     |> assign_email_and_password_changesets()}
  end

  def handle_event("update_email", params, socket) do
    %{"contato_model" => %{"current_password" => password} = contact_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, contact_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.contato.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

        {:noreply,
         socket
         |> put_flash(
           :info,
           dgettext(
             "infos",
             "A link to confirm your email change has been sent to the new address."
           )
         )
         |> redirect(to: Routes.user_settings_path(socket, :edit, user_id: user.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("update_password", params, socket) do
    %{"user_model" => %{"current_password" => password} = user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, dgettext("infos", "Password updated successfully."))
         |> UserAuth.log_in_user(user)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp assign_email_and_password_changesets(socket) do
    user = socket.assigns.current_user

    socket
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
