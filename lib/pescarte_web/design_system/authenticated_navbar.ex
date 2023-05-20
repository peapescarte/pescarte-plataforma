defmodule PescarteWeb.DesignSystem.AuthenticatedNavbar do
  use PescarteWeb, :live_component

  alias Pescarte.Domains.Accounts.Models.User

  attr :user, User, required: true
  attr :open, :boolean, default: nil

  @impl true
  def render(assigns) do
    ~H"""
    <header id="auth-navbar" phx-hook="NavbarHover" phx-target="#auth-navbar">
      <nav class={["h-full", "navbar", "authenticated", if(@open, do: "open")]}>
        <ul class="nav-menu">
          <li class="nav-item">
            <img :if={!@open} src={~p"/images/icon_logo.svg"} class="logo" />
            <img :if={@open} src={~p"/images/pescarte_logo.svg"} class="logo" />
          </li>
          <li class="nav-item">
            <Lucideicons.home />
            <.text :if={@open} size="base" color="text-black-60">Home</.text>
          </li>
          <li class="nav-item">
            <Lucideicons.users />
            <.text :if={@open} size="base" color="text-black-60">
              Pesquisadores
            </.text>
          </li>
          <li class="nav-item">
            <Lucideicons.file_text />
            <.text :if={@open} size="base" color="text-black-60">
              Relatórios
            </.text>
          </li>
          <li class="nav-item">
            <Lucideicons.calendar_days />
            <.text :if={@open} size="base" color="text-black-60">Agenda</.text>
          </li>
          <li class="nav-item">
            <Lucideicons.mail />
            <.text :if={@open} size="base" color="text-black-60">Mensagens</.text>
          </li>
        </ul>
        <div class="user-info">
          <Lucideicons.user class="text-black-60" />
          <.text :if={@open} size="base" color="text-black-80">
            Zoey de Souza Pessanha
          </.text>
        </div>
      </nav>
    </header>
    """
  end

  @impl true
  def handle_event("mouseover", _, socket) do
    {:noreply, assign(socket, open: true)}
  end

  def handle_event("mouseleave", _, socket) do
    {:noreply, assign(socket, open: false)}
  end
end
