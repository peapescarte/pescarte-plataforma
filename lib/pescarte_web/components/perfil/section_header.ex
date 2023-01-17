defmodule PescarteWeb.Components.Perfil.SectionHeader do
  use PescarteWeb, :html

  ##  alias PescarteWeb.Components.Icon

  def render(assigns) do
    ~H"""
    <div class="relative">
      <div class="navbar bg-blue-100 h-32 w-full"></div>
      <!-- faixa azul -->
      <div class="absolute bottom-0 ml-10">
        <!-- inserção de foto -->
        <div class="justify-center right-0 h-16">
          <img class="rounded-full w-16" src={@src} />
        </div>
      </div>
    </div>
    <div class="h-12"></div>
    """
  end
end
