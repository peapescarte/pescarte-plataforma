defmodule PescarteWeb.Components.Navbar.MenuLinks do
  @moduledoc """
  Componente que agrupa os links para a Navbar
  """

  use PescarteWeb, :component

  # alias Pescarte.Accounts.Models.UserModel

  alias PescarteWeb.Components.Button
  alias PescarteWeb.Components.Navbar.MenuItem

  def render(assigns) do
    ~H"""
    <%= if @conn.assigns.current_user do %>
      <%= for item <- authenticated_menu() do %>
        <MenuItem.render
          icon={item.icon}
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
      <Button.render label="Acessar" to="/acessar" />
    <% else %>
      <%= for item <- guest_menu() do %>
        <MenuItem.render
          icon={item.icon}
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
      <Button.render label="Acessar" to="/acessar" icon="login" />
    <% end %>
    """
  end

  def is_current_path?(%Plug.Conn{} = conn, to) do
    path = Enum.join(conn.path_info, "/")

    to =~ path
  end

  def guest_menu do
    [
      %{path: "/", label: "Home", method: :get, icon: "home"},
      %{path: "/pesquisa", label: "Pesquisa", method: :get, icon: "file"},
      %{path: "/biblioteca", label: "Biblioteca", method: :get, icon: "book"},
      %{
        path: "/agenda_socioambiental",
        label: "Agenda Socioambiental",
        method: :get,
        icon: "agenda"
      }
    ]
  end

  def authenticated_menu do
    [
      %{path: "/app/dashboard", label: "Home", method: :get, icon: "home"},
      %{path: "/app/pesquisadores", label: "Pesquisadores", method: :get, icon: "accounts"},
      %{path: "/app/relatorios", label: "Relatórios", method: :get, icon: "file"},
      %{path: "/app/agenda", label: "Agenda", method: :get, icon: "agenda"},
      %{path: "/app/mensagens", label: "Mensagens", method: :get, icon: "message"}
    ]
  end
end
