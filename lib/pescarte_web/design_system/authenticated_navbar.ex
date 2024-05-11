defmodule PescarteWeb.DesignSystem.AuthenticatedNavbar do
  use PescarteWeb, :live_component

  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Models.Usuario
  alias PescarteWeb.DesignSystem

  def mount(_params, _session, socket) do
    current_user = Repo.preload(socket.assigns.current_user, [:pesquisador])

    {:ok, assign(socket, pesquisador: current_user.pesquisador)}
  end

  attr(:user, Usuario, required: true)
  attr(:open, :boolean, default: nil)

  @impl true
  def render(assigns) do
    ~H"""
    <header id="auth-navbar" class="h-full" phx-hook="NavbarClick">
      <nav class={["navbar", "authenticated", if(@open, do: "open")]}>
        <img
          :if={!@open}
          class="arrow-open"
          src={~p"/images/seta.png"}
          style="transform: rotate(180deg)"
          phx-click="open_navbar"
          phx-target="#auth-navbar"
        />
        <img
          :if={@open}
          class="arrow-close"
          src={~p"/images/seta.png"}
          phx-click="close_navbar"
          phx-target="#auth-navbar"
        />
        <ul class="nav-menu">
          <li class="nav-item">
            <img :if={!@open} src={~p"/images/icon_logo.svg"} class="logo" />
            <img :if={@open} src={~p"/images/pescarte_logo.svg"} class="logo" />
          </li>
          <li class="nav-item">
            <DesignSystem.link navigate={~p"/"}>
              <Lucideicons.home />
              <.text :if={@open} size="base" color="text-black-60">Home</.text>
            </DesignSystem.link>
          </li>
          <li class="nav-item">
            <DesignSystem.link navigate={~p"/app/pesquisa/pesquisadores"}>
              <Lucideicons.users />
              <.text :if={@open} size="base" color="text-black-60">
                Pesquisadores
              </.text>
            </DesignSystem.link>
          </li>
          <li class="nav-item">
            <DesignSystem.link navigate={~p"/app/pesquisa/relatorios"}>
              <Lucideicons.file_text />
              <.text :if={@open} size="base" color="text-black-60">
                Relatórios
              </.text>
            </DesignSystem.link>
          </li>
          <li class="nav-item">
            <DesignSystem.link navigate={~p"/xxxx"}>
              <Lucideicons.calendar_days />
              <.text :if={@open} size="base" color="text-black-60">Agenda</.text>
            </DesignSystem.link>
          </li>
          <li class="nav-item">
            <DesignSystem.link navigate={~p"/xxx"}>
              <Lucideicons.mail />
              <.text :if={@open} size="base" color="text-black-60">Mensagens</.text>
            </DesignSystem.link>
          </li>
        </ul>
        <div class="user-info">
          <!-- <Lucideicons.user :if={!@pesquisador.link_avatar} width="100" height="100" /> -->
          <!-- <img :if={@pesquisador.link_avatar} src={@pesquisador.link_avatar} /> -->
          <.text :if={@open} size="base" color="text-black-80">
            <%= @user.primeiro_nome <> " " <> @user.sobrenome %>
          </.text>
        </div>
      </nav>
    </header>
    """
  end

  @impl true
  def handle_event("open_navbar", _, socket) do
    {:noreply, assign(socket, open: true)}
  end

  def handle_event("close_navbar", _, socket) do
    {:noreply, assign(socket, open: false)}
  end
end
