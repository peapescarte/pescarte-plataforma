defmodule FuschiaWeb.Components.Navbar do
  @moduledoc """
  A common Navbar component that wraps
  authenticated and public routes
  """

  use FuschiaWeb, :surface_component

  @doc "Conexão atual"
  prop socket, :struct, required: true

  alias FuschiaWeb.Components.Navbar.MenuLinks
  alias FuschiaWeb.Components.Navbar.MenuLogo

  def render(assigns) do
    ~F"""
    <nav class="navbar bg-white w-full">
      <div class="navbar-start p-1 w-3/4 flex justify-between lg:hidden">
        <div class="dropdown">
          <label tabindex="0">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="#F8961E">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h8m-8 6h16" />
            </svg>
          </label>
          <ul tabindex="0" class="menu menu-compact dropdown-content dropdown-left mt-3 p-2 shadow bg-white rounded-box w-52">
            <MenuLinks {=@socket} />
          </ul>
        </div>
        <MenuLogo hidden? />
      </div>
      <div class="navbar-center container hidden lg:flex lg:justify-center">
        <ul class="menu menu-horizontal p-0">
          <MenuLogo />
          <MenuLinks {=@socket} />
        </ul>
      </div>
    </nav>
    """
  end
end
