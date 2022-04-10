defmodule FuschiaWeb.Components.Navbar.MenuItem do
  @moduledoc """
  Componente que representa um único item dentro do menu.
  """

  use FuschiaWeb, :surface_component

  alias Surface.Components.Link

  @doc "Caminho do link de destino"
  prop path, :string, required: true

  @doc "Método HTTP usado no link"
  prop method, :atom, default: :get

  @doc "Define o texto do item"
  prop label, :string

  @doc "Define se o item é o atual"
  prop current?, :boolean

  def render(assigns) do
    ~F"""
    <div class="ui item v-align h-align">
      <Link
          to={@path} {=@method}
          class={"ui", "massive", "bold", "blue-darker", "text", "upper", "one", "wide", "column", active: @current?}
      >
        {@label}
      </Link>
    </div>
    """
  end
end
