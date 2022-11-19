defmodule PescarteWeb.Components.Perfil.SectionBody do
  use PescarteWeb, :component

  def render(assigns) do
    ~H"""
    <div class="ml-10 mr-4">
      <%= label(@field, @text, class: "text-black font-semibold") %>
      <blockquote>
        <span class="text-black grow"><%= @value %></span>
      </blockquote>
    </div>
    """
  end
end
