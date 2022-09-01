defmodule FuschiaWeb.Components.Navbar.MenuItem do
  @moduledoc """
  Componente que representa um único item dentro do menu.
  """

  use FuschiaWeb, :component

  def render(assigns) do
    ~H"""
    <li>
      <%= link(@label,
        to: @path,
        method: @method,
        class: "uppercase mx-4 #{get_current_style(@current?)} text-2xl font-semibold",
        active: @current?
      ) %>
    </li>
    """
  end

  def get_current_style(true), do: "text-white"
  def get_current_style(false), do: "text-blue-500"
end
