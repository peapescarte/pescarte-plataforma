defmodule FuschiaWeb.UserResetPasswordLive.New do
  @moduledoc false

  use FuschiaWeb, :live_view

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias Surface.Components.Form
  alias Surface.Components.Form.{EmailInput, Field, Label}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("send", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &Routes.user_reset_password_url(socket, :edit, &1)
      )
    end

    {:noreply,
     socket
     |> put_flash(
       :info,
       dgettext(
         "infos",
         "If your email is in our system, you will receive instructions to reset your password shortly."
       )
     )
     |> redirect(to: "/")}
  end
end
