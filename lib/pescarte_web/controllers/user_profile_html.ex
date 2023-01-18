defmodule PescarteWeb.UserProfileHTML do
  use PescarteWeb, :html

  embed_templates "user_profile_html/*"

  def header(assigns) do
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

  def nameBursary(assigns) do
    ~H"""
    <div class="flex items-center flex-column space-x-10 w-10/12 h-15">
      <div class="text-black font-semibold text-2xl text-left justify-between md:w-1/2">
        <h1><%= @name %></h1>
        <h1><%= @bursary %></h1>
      </div>
    </div>
    """
  end

  def headerRight(assigns) do
    ~H"""
    <label tabindex="0" class="btn m-1">
      <%= @label %>
    </label>
    """
  end
end
