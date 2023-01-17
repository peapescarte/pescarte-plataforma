defmodule PescarteWeb.Components.Pesquisador.MenuHeader do
  @moduledoc """
  Componente que representa um único item dentro do header do pesquisador.
  """

  use PescarteWeb, :html

  def render(assigns) do
    ~H"""
    <li class="menu-item">
      <form action={@to} method="get">
        <input type="search" class="rounded-full h-16" wrapper_class="w-1/3 m-4" />
        <%= @label %>
      </form>
    </li>
    """
  end
end
