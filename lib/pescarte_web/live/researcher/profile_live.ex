defmodule PescarteWeb.Researcher.ProfileLive do
  use PescarteWeb, :auth_live_view

  @impl true
  def mount(_params, _session, socket) do
    # current_user = socket.assigns.current_user
    mock_user = %{
      avatar: nil,
      profile_banner: nil,
      first_name: "Zoey",
      last_name: "Pessanha",
      pesquisador: %{
        minibio: "Olá sou eu mesma!",
        link_lattes: "https://github.com/zoedsoupe",
        link_linkedin: "https://linkedin.com/in/zoedsoupe",
        bolsa: :pesquisa
      }
    }

    {:ok, assign(socket, user: mock_user)}
  end

  # Components

  attr :href, :string, required: true
  attr :label, :string, required: true

  slot :inner_block

  def profile_link(assigns) do
    ~H"""
    <div class="flex items-center justify-between w-28">
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

  attr :label, :string, required: true
  attr :click, :string, required: true

  slot :inner_block

  def profile_menu_link(assigns) do
    ~H"""
    <div class="profile-menu-link">
      <span class="flex items-center justify-center bg-white-100 h-12 w-12">
        <%= render_slot(@inner_block) %>
      </span>
      <.button style="primary" class="whitespace-nowrap" click={@click}>
        <.text size="base" color="text-blue-80">
          <%= @label %>
        </.text>
      </.button>
    </div>
    """
  end
end
