defmodule PescarteWeb.Components.Navbar.MenuItem do
  @moduledoc """
  Componente que representa um único item dentro do menu.
  """

  use PescarteWeb, :component

  alias PescarteWeb.Components.Icon

  def render(assigns) do
    ~H"""
    <li class="menu-item">
      <%= link to: @path, method: @method, active: @current? do %>
        <Icon.render name={@icon} />
        <%= @label %>
      <% end %>
    </li>
    """
  end
end
