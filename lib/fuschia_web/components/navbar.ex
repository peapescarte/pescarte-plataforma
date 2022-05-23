defmodule FuschiaWeb.Components.Navbar do
  @moduledoc """
  A common Navbar component that wraps
  authenticated and public routes
  """

  use FuschiaWeb, :surface_component

  @doc "Conexão atual"
  prop socket, :struct, required: true

  alias FuschiaWeb.Components.Navbar.MenuLinks

  def render(assings) do
    ~F"""
    <div class="ui fixed borderless colossal menu">
      <div class="ui container grid">
        <div class="computer only row">
          <MenuLinks {=@socket} />
        </div>
        <div class="tablet mobile only row">
          <MenuLinks {=@socket} />
        </div>
      </div>
    </div>
    """
  end
end
