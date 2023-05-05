defmodule PescarteWeb.LoginHTML do
  use PescarteWeb, :html

  def show(assigns) do
    assigns = Map.put(assigns, :form, to_form(%{}, as: :user))

    ~H"""
    <main class="fish-bg h-full">
      <.simple_form for={@form} action={~p"/acessar"} id="login_form">
        <.text size="h3" color="text-black-80">
          Faça login para acessar a plataforma
        </.text>

        <fieldset class="login-fieldset">
          <.text_input field={@form[:cpf]} type="text" mask="999.999.999-99" label="CPF" required />
        </fieldset>

        <fieldset class="login-fieldset">
          <.text_input field={@form[:password]} type="password" label="Senha" required />
        </fieldset>

        <:actions>
          <.checkbox field={@form[:remember_me]} label="Mantanha-me conectado" id="remember" />

          <DesignSystem.link href={~p"/usuarios/recuperar_senha"} class="text-sm font-semibold">
            <.text size="sm">Esqueceu sua senha?</.text>
          </DesignSystem.link>
        </:actions>

        <:actions>
          <.button style="primary" submit>
            <.text size="lg">Acessar</.text>
          </.button>
        </:actions>
      </.simple_form>
    </main>
    """
  end
end
