defmodule PescarteWeb.Components.Perfil.SectionHeaderRight do
  use PescarteWeb, :html

  def render(assigns) do
    ~H"""
    <label tabindex="0" class="btn m-1">
      <%= @label %>
    </label>
    """
  end
end
