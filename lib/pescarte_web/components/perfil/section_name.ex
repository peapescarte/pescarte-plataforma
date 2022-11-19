defmodule PescarteWeb.Components.Perfil.SectionName do
  use PescarteWeb, :component

  def render(assigns) do
  ~H"""
  <div class="flex items-center flex-column space-x-10 w-10/12 h-15">
    <div class="text-black font-semibold text-2xl text-left justify-between md:w-1/2">
      <h1><%= @name %></h1>
      <h1><%= @bursary %></h1>
    </div>
  </div>
  """
  end
end
