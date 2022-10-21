defmodule BackendWeb.Components.Navbar.MenuLinks do
  @moduledoc """
  Componente que agrupa os links para a Navbar
  """

  use BackendWeb, :component

  # alias Backend.Accounts.Models.UserModel
  import BackendWeb.Components, only: [icon: 1]

  alias BackendWeb.Components.Navbar.MenuItem
  alias BackendWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <%= if @conn.assigns.current_user do %>
      <%= for item <- authenticated_menu(@conn) do %>
        <MenuItem.render
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
    <% else %>
      <%= for item <- guest_menu(@conn) do %>
        <%= case item.type do %>
          <% :link -> %>
            <MenuItem.render
              path={item.path}
              label={item.label}
              method={item.method}
              current?={is_current_path?(@conn, item.path)}
            />
          <% :dropdown -> %>
            <li tabindex="0">
              <span class="uppercase text-2xl font-semibold text-blue-500">
                <%= item.label %>
                <.icon name={:dropdown} />
              </span>
              <ul class="p-2 bg-white">
                <%= for link <- item.items do %>
                  <MenuItem.render
                    path={link.path}
                    label={link.label}
                    method={link.method}
                    current?={is_current_path?(@conn, link.path)}
                  />
                <% end %>
              </ul>
            </li>
        <% end %>
      <% end %>
    <% end %>
    """
  end

  def is_current_path?(%Plug.Conn{} = conn, to) do
    path = Enum.join(conn.path_info, "/")

    to =~ path
  end

  def guest_menu(conn) do
    login_path = Routes.user_session_path(conn, :new)

    [
      build_menu_item("projeto", "/projeto"),
      build_menu_item("contato", "/contato"),
      build_menu_item("censo da pesca", "/censo"),
      build_dropdown("galeria", [
        build_menu_item("fotos", "/galeria/fotos"),
        build_menu_item("vídeos", "/galeria/videos"),
        build_menu_item("documentos", "/galeria/documentos"),
        build_menu_item("relatórios", "/galeria/relatorios"),
        build_menu_item("podcast", "/galeria/podcast")
      ]),
      build_dropdown("setores", [
        build_menu_item("campo", "/campo"),
        build_menu_item("pesquisa", "/pesquisa"),
        build_menu_item("pedagógico", "/pedagogico")
      ]),
      build_dropdown("extras", [
        build_menu_item("museu da pesca", "/museu-da-pesca"),
        build_menu_item("pgtrs", "/pgtrs"),
        build_menu_item("agenda socioambiental", "/agenda-socioambiental")
      ]),
      build_menu_item("acessar", login_path)
    ]
  end

  def authenticated_menu(conn) do
    logout_path = Routes.user_session_path(conn, :delete)

    [
      build_menu_item("perfil", "/app/perfil"),
      build_menu_item("relatórios", "/app/relatorios"),
      build_menu_item("mídias", "/app/midias"),
      build_menu_item("agenda", "/app/agenda"),
      build_menu_item("notificações", "/app/notificacoes"),
      build_menu_item("sair", logout_path, :delete)
    ]
  end

  defp build_menu_item(label, path, method \\ :get) do
    Map.new()
    |> Map.put(:path, path)
    |> Map.put(:label, label)
    |> Map.put(:method, method)
    |> Map.put(:type, :link)
  end

  defp build_dropdown(label, items) do
    Map.new()
    |> Map.put(:label, label)
    |> Map.put(:items, items)
    |> Map.put(:type, :dropdown)
  end
end
