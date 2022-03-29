defmodule FuschiaWeb.Components.Navbar.MenuItem do
  @moduledoc """
  Componente que representa um único item dentro do menu.
  """

  use FuschiaWeb, :surface_component

  alias Surface.Components.Link

  @doc "Caminho do link de destino"
  prop path, :string, required: true

  @doc "Define se o item é o atual"
  prop current?, :boolean

  slot default, required: true

  def render(assigns) do
    ~F"""
    <Link to={@path} class={"text", "upper", active: @current?}>
      <#slot />
    </Link>
    """
  end
end
