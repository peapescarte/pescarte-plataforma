defmodule FuschiaWeb.LiveComponents.Navbar.MenuItem do
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
    <li>
      <Link
        to={@path} {=@method}
        class={
          "uppercase", "mx-4",
          (if @current?, do: "text-white", else:  "text-blue-500"),
          "text-2xl", "font-semibold", active: @current?}
      >
        {@label}
      </Link>
    </li>
    """
  end
end
