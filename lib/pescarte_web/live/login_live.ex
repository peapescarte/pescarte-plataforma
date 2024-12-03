defmodule PescarteWeb.LoginLive do
  use PescarteWeb, :live_view

  alias Supabase.GoTrue

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(current_path: "/acessar")
     |> assign(form: to_form(%{}, as: :user))
     |> assign(reset_form: to_form(%{}, as: :reset_pass))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <style>
      #reset-password-content fieldset {
        width: 100%;
      }

      #reset-password-content fieldset input {
        width: 100%;
      }
    </style>

    <.form for={@reset_form} phx-submit="trigger_reset_pass">
      <.modal id="reset-password" title="Recuperar Senha">
        <div class="flex flex-col justify-between items-start" style="gap: 32px;">
          <.text_input
            field={@reset_form[:email]}
            type="email"
            label="E-mail"
            phx-keyup="trigger_reset_pass"
            required
          />
        </div>
        <:footer class="flex justify-center items-center">
          <.button style="primary" class="mx-auto" submit>
            Me Envie Instruções para a Recuperação
          </.button>
        </:footer>
      </.modal>
    </.form>

    <div class="fish-bg h-full" id="login-wrapper">
      <.flash id="login-flash" kind={:error} flash={@flash} />

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

            <DesignSystem.link
              class="text-sm font-semibold"
              on-click={DesignSystem.show_modal("reset-password")}
            >
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

  @reset_msg "Caso seu email esteja cadastrado, um email para recuperação de senha será enviado"

  @impl true
  def handle_event("trigger_reset_pass", %{"key" => "Enter", "value" => email}, socket) do
    {:ok, client} = Pescarte.get_supabase_client()
    :ok = GoTrue.reset_password_for_email(client, email, redirect_to: ~p"/confirmar")

    {:noreply,
     socket
     |> put_flash(:success, @reset_msg)
     |> push_navigate(to: ~p"/acessar")}
  end

  def handle_event("trigger_reset_pass", %{"reset_pass" => %{"email" => email}}, socket) do
    {:ok, client} = Pescarte.get_supabase_client()
    :ok = GoTrue.reset_password_for_email(client, email, redirect_to: ~p"/confirmar")

    {:noreply,
     socket
     |> put_flash(:success, @reset_msg)
     |> push_navigate(to: ~p"/acessar")}
  end

  def handle_event("trigger_reset_pass", _params, socket) do
    {:noreply, socket}
  end
end
