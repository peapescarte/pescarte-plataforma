defmodule PescarteWeb.UserLoginLive do
  use PescarteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.simple_form :let={f} for={:user} action={~p"/acessar"} id="login_form" phx-update="ignore">
      <.input field={{f, :cpf}} label="CPF" id="user_cpf" error?={!!@error} required />
      <.input field={{f, :password}} label="Senha" type="password" error?={!!@error} required />

      <.error :if={@error}>
        <%= @error %>
      </.error>

      <:actions :let={f}>
        <.input field={{f, :remember_me}} type="checkbox" label="Mantanha-me conectado" />
        <.link href={~p"/usuarios/recuperar_senha"} class="text-sm font-semibold">
          <.text size="sm">
            Esqueceu sua senha?
          </.text>
        </.link>
      </:actions>

      <:actions>
        <.button type="submit" style="primary">
          <.text size="lg">
            Acessar
          </.text>
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email), temporary_assigns: [email: nil, error: nil]}
  end
end
