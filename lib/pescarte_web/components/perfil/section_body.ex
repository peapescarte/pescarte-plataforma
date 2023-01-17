defmodule PescarteWeb.Components.Perfil.SectionBody do
  use PescarteWeb, :html

  def render(assigns) do
    ~H"""
    <div class="ml-10 mr-4">
      
      <blockquote>
        <span class="text-black grow"><%= @value %></span>
      </blockquote>
    </div>
    """
  end
end
