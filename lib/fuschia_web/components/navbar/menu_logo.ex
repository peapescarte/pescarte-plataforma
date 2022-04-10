defmodule FuschiaWeb.Components.Navbar.MenuLogo do
  @moduledoc false

  use FuschiaWeb, :surface_component

  def render(assigns) do
    ~F"""
    <img
      class="ui logo v-align centered image one wide column"
      src="/images/logos/pescarte_full.png"
      alt="Logo completo do projeto com os dez peixinhos e nome"
    />
    """
  end
end
