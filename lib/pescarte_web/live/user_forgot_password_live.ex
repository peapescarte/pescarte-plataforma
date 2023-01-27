defmodule PescarteWeb.UserForgotPasswordLive do
  use PescarteWeb, :live_view

  alias Pescarte.Domains.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Esqueceu sua senha?
        <:subtitle>Mandaremos um link para recuperação da senha para seu email</:subtitle>
      </.header>

      <.simple_form :let={f} id="reset_password_form" for={:user} phx-submit="send_email">
        <.input field={{f, :email}} type="email" placeholder="Email" required />
        <:actions>
          <.button style="primary" phx-disable-with="Enviando..." class="w-full">
            Enviar instruções de recuperação
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center mt-4">
        <.link href={~p"/acessar"}>Acessar plataforma</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/usuarios/recuperar_senha/#{&1}")
      )
    end

    info = "Caso seu email esteja no sistema, você receberá as instruções em breve."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
