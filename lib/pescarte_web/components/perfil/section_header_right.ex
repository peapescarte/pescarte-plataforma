defmodule PescarteWeb.Components.Perfil.SectionHeaderRight do
  use PescarteWeb, :component

  alias PescarteWeb.Components.Icon

  def render(assigns) do
    ~H"""
    <label tabindex="0" class="btn m-1">
      <Icon.render name={@icon} />
      <%= @label %>
    </label>
    """
  end
end
