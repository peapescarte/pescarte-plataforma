defmodule PescarteWeb.Components.Pesquisador.SectionHeader do
  use PescarteWeb, :html

  alias PescarteWeb.Components.Navbar.MenuItem

  def render(assigns) do
    ~H"""
    <%= for item <- navbar_menu() do %>
        <MenuItem.render
          icon={item.icon}
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
    """
  end

  def is_current_path?(%Plug.Conn{} = conn, to) do
    path = Enum.join(conn.path_info, "/")

    to =~ path
  end

  def navbar_menu do
    [
      %{path: "/app/perfil", label: "Buscar por Pesquisador(a)", method: :get, icon: "search"},
      %{path: "/recuperar_senha/:token", label: "Filtros", method: :get, icon: "filter"},
      %{path: "/admin/pesq/novo", label: "Cadastrar", method: :new, icon: "accounts"}
    ]

  end


end
