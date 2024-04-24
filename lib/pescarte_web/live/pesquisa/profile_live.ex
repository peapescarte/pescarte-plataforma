defmodule PescarteWeb.Pesquisa.ProfileLive do
  use PescarteWeb, :auth_live_view

  import Phoenix.Naming, only: [humanize: 1]

  alias Pescarte.Identidades.Models.Usuario
  alias Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    %Usuario{} = current_usuario = socket.assigns.current_usuario

    {:ok,
     assign(socket,
       user_name: Usuario.build_usuario_name(current_usuario),
       bolsa: humanize(current_usuario.pesquisador.bolsa),
       minibio: current_usuario.pesquisador.minibio,
       link_lattes: current_usuario.pesquisador.link_lattes,
       link_linkedin: current_usuario.pesquisador.link_linkedin,
       link_banner: current_usuario.pesquisador.link_banner_perfil,
       link_avatar: current_usuario.link_avatar
     )}
  end

  # Components

  attr(:href, :string, required: true)
  attr(:label, :string, required: true)

  slot(:inner_block)

  def profile_link(assigns) do
    ~H"""
    <div class="flex items-center profile-link">
      <span class="rounded-full bg-blue-80 h-12 w-12 flex-center">
        <%= render_slot(@inner_block) %>
      </span>
      <DesignSystem.link href={@href} class="w-12 text-left link">
        <.text size="base" color="text-blue-80">
          <%= @label %>
        </.text>
      </DesignSystem.link>
    </div>
    """
  end

  @impl true
  def handle_event("edit_profile", _, socket) do
    {:noreply, socket}
  end

  def handle_event("change_pass", _, socket) do
    {:noreply, socket}
  end
end
