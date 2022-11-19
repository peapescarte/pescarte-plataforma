defmodule PescarteWeb.Components.Perfil.SectionFooter do
  use PescarteWeb, :component

  alias PescarteWeb.Components.Icon

  def render(assigns) do
    ~H"""
      <div class="flex items-center space-x-4 flex-row h-12">
        <Icon.render name={@name} />
        <a href={@value} class="text-blue link link-hover"><%= @text%></a>
      </div>
    """
  end
end
