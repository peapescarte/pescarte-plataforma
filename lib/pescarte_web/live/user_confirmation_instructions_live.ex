defmodule PescarteWeb.UserConfirmationInstructionsLive do
  use PescarteWeb, :live_view

  alias Pescarte.Domains.Accounts

  def render(assigns) do
    ~H"""
    <.header>Reenviar email de confirmação</.header>

    <.simple_form :let={f} for={:user} id="resend_confirmation_form" phx-submit="send_instructions">
      <.input field={{f, :email}} type="email" label="Email" required />
      <:actions>
        <.button style="primary" phx-disable-with="Enviando...">
          Reenviar instruções de confirmação
        </.button>
      </:actions>
    </.simple_form>

    <p>
      <.link href={~p"/acessar"}>Acessar plataforma</.link>
    </p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/usuarios/confirmar/#{&1}")
      )
    end

    info =
      "Caso seu email esteja no sistema e ainda não tenha sido confirmado, um email com as instruções chegará em breve"

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
