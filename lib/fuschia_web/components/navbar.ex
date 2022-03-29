defmodule FuschiaWeb.Components.Navbar do
  @moduledoc """
  A common Navbar component that wraps
  authenticated and public routes
  """

  use FuschiaWeb, :surface_component

  @doc "Conexão atual"
  prop socket, :struct, required: true

  alias FuschiaWeb.Components.Navbar.MenuLinks
end
