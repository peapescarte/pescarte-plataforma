defmodule PescarteWeb.DesignSystem.AuthenticatedNavbar do
  use PescarteWeb, :live_component

  alias Pescarte.Identidades.Models.Usuario
  alias PescarteWeb.DesignSystem

  attr :user, Usuario, required: true
  attr :open, :boolean, default: nil
  attr :menus, :any, default: []
  attr :current_path, :string

  @impl true
  def render(assigns) do
    ~H"""
    <header id="auth-navbar" class="h-full" phx-hook="NavbarHover" phx-target="#auth-navbar">
      <nav class={["navbar", "authenticated", if(@open, do: "open")]}>
        <span>
          <Lucideicons.arrow_right :if={!@open} />
          <Lucideicons.arrow_left :if={@open} />
        </span>
        <ul class="nav-menu">
          <li class="nav-item">
            <img :if={!@open} src={~p"/images/icon_logo.svg"} class="logo-auth" />
            <img :if={@open} src={~p"/images/pescarte_logo.svg"} class="logo-auth" />
          </li>

          <DesignSystem.link :for={{menu_name, path, icon} <- @menus} navigate={path}>
            <li class={"nav-item #{if should_activate_menu_item(path, @current_path), do: "active"}"}>
              <.icon name={icon} class="text-black-60" />
              <.text :if={@open} size="base" color="text-black-60"><%= menu_name %></.text>
            </li>
          </DesignSystem.link>
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

  defp should_activate_menu_item(path, current_path) do
    case Regex.match?(~r/^#{path}(\/|$)/, current_path) do
      true -> true
      false -> false
    end
  end
end
