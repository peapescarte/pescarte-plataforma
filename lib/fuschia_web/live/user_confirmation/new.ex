defmodule FuschiaWeb.UserConfirmationLive.New do
  @moduledoc false

  use FuschiaWeb, :live_view

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias Surface.Components.Form
  alias Surface.Components.Form.{EmailInput, Field, Label}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("resend", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(socket, :edit, &1)
      )
    end

    {:noreply,
     socket
     |> put_flash(
       :info,
       dgettext(
         "infos",
         "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
       )
     )
     |> redirect(to: "/app")}
  end
end
