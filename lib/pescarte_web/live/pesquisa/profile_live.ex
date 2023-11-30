defmodule PescarteWeb.Pesquisa.ProfileLive do
  use PescarteWeb, :auth_live_view

  alias PescarteWeb.Authentication

  @impl true
  def mount(_params, _session, socket) do
    #  current_user = socket.assigns.current_user
    current_user = Pescarte.Database.Repo.preload(socket.assigns.current_user, [:pesquisador])

    {:ok,
     assign(socket, user_name: current_user.primeiro_nome, pesquisador: current_user.pesquisador)}
  end

  # Components

  attr :href, :string, required: true
  attr :label, :string, required: true

  slot :inner_block

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

  attr :label, :string, required: true
  attr :click, :string, required: true

  slot :inner_block

  def profile_menu_link(assigns) do
    ~H"""
    <div class="profile-menu-link">
      <span class="flex items-center justify-center bg-white-100">
        <%= render_slot(@inner_block) %>
      </span>
      <.button style="link" class="whitespace-nowrap" click={@click} phx-target=".profile-menu-link">
        <.text size="base" color="text-blue-80" class="bg-white-100">
          <%= @label %>
        </.text>
      </.button>
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

  def handle_event("logout", _, socket) do
    Authentication.log_out_user(socket)
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/")}
  end
end
