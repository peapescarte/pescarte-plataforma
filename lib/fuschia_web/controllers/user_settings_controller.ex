defmodule FuschiaWeb.UserSettingsController do
  use FuschiaWeb, :controller

  alias Fuschia.Accounts
  alias FuschiaWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"contato_model" => %{"current_password" => password} = contact_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, contact_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.contato.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit, user_id: user.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"user_model" => %{"current_password" => password} = user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    user = conn.assigns.current_user

    case Accounts.update_user_email(user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit, user_id: user.id))

      :error ->
        conn
        |> put_flash(
          :error,
          "Email change link is invalid or it has expired."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit, user_id: user.id))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
