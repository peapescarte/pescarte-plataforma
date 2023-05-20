defmodule PescarteWeb.LoginHTML do
  use PescarteWeb, :html

  def show(assigns) do
    assigns = Map.put(assigns, :form, to_form(%{}, as: :user))

    ~H"""
    <main class="fish-bg h-full">
      <.toast :if={@error_message} id="login-error" type="error" message={@error_message} />

      <.simple_form for={@form} action={~p"/acessar"} class="login-form">
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
          <div class="flex justify-between items-center">
            <.checkbox field={@form[:remember_me]} label="Mantanha-me conectado" id="remember" />

            <DesignSystem.link href={~p"/usuarios/recuperar_senha"} class="text-sm font-semibold">
              <.text size="sm">Esqueceu sua senha?</.text>
            </DesignSystem.link>
          </div>
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
