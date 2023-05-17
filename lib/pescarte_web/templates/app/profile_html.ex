defmodule PescarteWeb.App.ResearcherHTML do
  use PescarteWeb, :html

  embed_templates "researcher_html/*"

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
  attr :"phx-click", :any, required: true

  slot :inner_block

  def profile_menu_link(assigns) do
    ~H"""
    <div class="profile-menu-link">
      <span class="flex items-center justify-center bg-white-100 h-12 w-12">
        <%= render_slot(@inner_block) %>
      </span>
      <.button
        phx-click={Map.get(assigns, :"phx-click")}
        phx-target={@myself}
        style="primary"
        class="whitespace-nowrap"
      >
        <.text size="base" color="text-blue-80">
          <%= @label %>
        </.text>
      </.button>
    </div>
    """
  end
end
