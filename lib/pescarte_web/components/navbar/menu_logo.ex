defmodule PescarteWeb.Components.Navbar.MenuLogo do
  @moduledoc false

  use PescarteWeb, :component

  def render(assigns) do
    ~H"""
    <figure>
      <img
        class={["mt-3", "#{get_hidden_style(@hidden?)}"]}
        src="/images/pescarte_logo.svg"
        alt="Logo completo do projeto com os dez peixinhos e nome"
        width="150"
      />
    </figure>
    """
  end

  def get_hidden_style(true), do: "lg:hidden"
  def get_hidden_style(false), do: ""
end
