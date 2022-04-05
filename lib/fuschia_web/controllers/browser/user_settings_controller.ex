defmodule FuschiaWeb.UserSettingsController do
  use FuschiaWeb, :controller

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts

  def confirm_email(conn, %{"token" => token}) do
    user = conn.assigns.current_user

    case Accounts.update_user_email(user, token) do
      :ok ->
        conn
        |> put_flash(:info, dgettext("infos", "Email changed successfully."))
        |> redirect(to: Routes.user_settings_path(conn, :edit, user_id: user.id))

      :error ->
        conn
        |> put_flash(
          :error,
          dgettext("errors", "Email change link is invalid or it has expired.")
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit, user_id: user.id))
    end
  end
end
