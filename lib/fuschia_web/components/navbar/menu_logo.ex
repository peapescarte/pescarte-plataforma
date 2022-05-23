defmodule FuschiaWeb.Components.Navbar.MenuLogo do
  @moduledoc false

  use FuschiaWeb, :surface_component

  prop hidden?, :boolean, default: false

  def render(assigns) do
    ~F"""
    <figure>
      <img
        class={["lg:hidden": @hidden?]}
        src="/images/pescarte_logo.png"
        alt="Logo completo do projeto com os dez peixinhos e nome"
        align="middle"
        width="200"
      />
    </figure>
    """
  end
end
