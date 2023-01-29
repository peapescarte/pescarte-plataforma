defmodule PescarteWeb.UserProfileLive do
  use PescarteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  ## Events

  ## Components

  def avatar(assigns) do
    ~H"""
    <div class="user-profile-avatar">
      <%= if @current_user.pesquisador.avatar do %>
        <img src={@current_user.pesquisador.avatar} />
      <% else %>
        <Lucideicons.user width="100" height="100" />
      <% end %>
    </div>
    """
  end

  def banner(assigns) do
    ~H"""
    <div class="user-profile-banner">
      <%= if @current_user.pesquisador.profile_banner do %>
        <img src={@current_user.pesquisador.profile_banner} />
      <% else %>
        <div class="user-profile-banner-default"></div>
      <% end %>
    </div>
    """
  end

  def user_profile_menu(assigns) do
    ~H"""
    <div class="user-profile-menu-dots">
      <div class="dots">
        <span /> <span /> <span />
      </div>
    </div>
    <div class="user-profile-menu">
      <.profile_menu_link on_click="edit_profile" label="Editar Perfil">
        <Lucideicons.edit />
      </.profile_menu_link>

      <.profile_menu_link on_click="change_pass" label="Alterar Senha">
        <Lucideicons.lock />
      </.profile_menu_link>

      <.profile_menu_link on_click="logout" label="Sair">
        <Lucideicons.log_out />
      </.profile_menu_link>
    </div>
    """
  end

  attr :on_click, :string, required: true
  attr :label, :string, required: true

  slot :inner_block, required: true

  defp profile_menu_link(assigns) do
    ~H"""
    <div class="flex justify-between items-center w-28">
      <span class="flex items-center justify-center bg-white-100 h-12 w-12">
        <%= render_slot(@inner_block) %>
      </span>
      <.button style="link" phx-click={@on_click}>
        <.text size="base" color="blue-80" text_case="capitalize">
          <%= @label %>
        </.text>
      </.button>
    </div>
    """
  end

  attr :href, :string, required: true
  attr :label, :string, required: true

  slot :inner_block, required: true

  def profile_link(assigns) do
    ~H"""
    <div class="flex justify-between items-center w-28">
      <span class="flex items-center justify-center rounded-full bg-blue-80 h-12 w-12">
        <%= render_slot(@inner_block) %>
      </span>
      <.link
        href={@href}
        class="w-12 text-left hover:underline decoration-from-font decoration-blue-80"
      >
        <.text size="base" color="blue-80" text_case="capitalize">
          <%= @label %>
        </.text>
      </.link>
    </div>
    """
  end

  def full_name(user) do
    names = [user.first_name, user.middle_name, user.last_name]

    Enum.join(names, " ")
  end
end
