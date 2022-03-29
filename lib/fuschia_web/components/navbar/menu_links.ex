defmodule FuschiaWeb.Components.Navbar.MenuLinks do
  @moduledoc """
  Componente que agrupa os links para a Navbar
  """

  use FuschiaWeb, :surface_component

  # alias Fuschia.Accounts.Models.UserModel
  alias FuschiaWeb.Components.Navbar.MenuItem
  alias FuschiaWeb.Router.Helpers, as: Routes

  @doc "Conexão atual"
  prop socket, :struct, required: true

  def render(assigns) do
    ~F"""
    {#if @socket.assigns.current_user}
      {#for item <- authenticated_menu(@socket)}
        <MenuItem path={item.path}>
          {item.label}
        </MenuItem>
      {/for}
    {#else}
      {#for item <- guest_menu(@socket)}
        <MenuItem path={item.path}>
          {item.label}
        </MenuItem>
      {/for}
    {/if}
    """
  end

  def guest_menu(socket) do
    # TODO change hardcoded paths to Router helpers
    [
      %{path: "/projeto", label: "o projeto"},
      %{path: "/campo", label: "campo"},
      %{path: "/pesquisa", label: "pesquisa"},
      %{path: "/pedagogico", label: "pedagógico"},
      %{path: "/museu-da-pesca", label: "museu da pesca"},
      %{path: "/banco-de-dados", label: "banco de dados"},
      %{path: "/pgtrs", label: "pgtrs"},
      %{path: "/censo", label: "censo da pesca"},
      %{path: "/agenda-socioambiental", label: "agenda socioambiental"},
      %{path: Routes.user_session_path(socket, :new), label: "acessar"},
      %{path: "/contato", label: "contato"}
    ]
  end

  def authenticated_menu(socket) do
    # TODO change hardcoded paths to Router helpers
    [
      %{path: "/app/perfil", label: "perfil"},
      %{path: "/app/relatorios", label: "relatórios"},
      %{path: "/app/midias", label: "mídias"},
      %{path: "/app/agenda", label: "agenda"},
      %{path: "/app/notificacoes", label: "notificações"},
      %{path: Routes.user_session_path(socket, :delete), label: "sair"}
    ]
  end
end
