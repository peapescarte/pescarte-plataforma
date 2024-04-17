defmodule PescarteWeb.LoginHTML do
  use PescarteWeb, :html

  def show(assigns) do
    assigns = Map.put(assigns, :form, to_form(%{}, as: :user))

    ~H"""
    <div class="fish-bg h-full" id="login-wrapper">
      <.flash :if={@error_message} id="login-error" kind={:error}>
        <%= @error_message %>
      </.flash>

      <.simple_form for={@form} action={~p"/acessar"} class="login-form">
        <.text size="h3" color="text-black-80">
          Faça login para acessar a plataforma
        </.text>

        <fieldset class="login-fieldset">
          <.text_input field={@form[:cpf]} type="text" label="CPF" required phx-hook="CpfNumberMask" />
        </fieldset>

        <fieldset class="login-fieldset">
          <.text_input field={@form[:password]} type="password" label="Senha" required />
        </fieldset>

        <:actions>
          <div class="flex justify-between items-center">
            <.checkbox field={@form[:remember_me]} label="Lembre de mim" id="remember" />

            <DesignSystem.link href="/usuarios/recuperar_senha" class="text-sm font-semibold">
              <.text size="sm">Esqueci minha senha</.text>
            </DesignSystem.link>
          </div>
        </:actions>

        <:actions>
          <.button style="primary" submit>
            <.text size="lg">Acessar</.text>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
