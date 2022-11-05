defmodule PescarteWeb.UserProfileController do
  use PescarteWeb, :controller

  alias Pescarte.Accounts
  alias PescarteWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "edit.html", user: user, edit?: false)
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

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "show.html", user: user)
  end

  def confirm_email(conn, %{"token" => token}) do
    user = conn.assigns.current_user

    case Accounts.update_user_email(user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_profile_path(conn, :edit, user_id: user.id))

      :error ->
        conn
        |> put_flash(
          :error,
          "Email change link is invalid or it has expired."
        )
        |> redirect(to: Routes.user_profile_path(conn, :edit, user_id: user.id))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
