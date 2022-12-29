defmodule PescarteWeb.Components.Perfil.HeaderLinks do
  @moduledoc """
  Componente que agrupa os links para o dropdown no perfil do pesquisador
  """
  use PescarteWeb, :component
  alias PescarteWeb.Components.Navbar.MenuItem

  def render(assigns) do
    ~H"""
    <%= if @conn.assigns.current_user do %>
      <%= for item <- drop_menu() do %>
        <MenuItem.render
          icon={item.icon}
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
    <% end %>
    """
  end

  def is_current_path?(%Plug.Conn{} = conn, to) do
    path = Enum.join(conn.path_info, "/")

    to =~ path
  end

  def drop_menu do
    [
      %{path: "/app/perfil", label: "Editar Perfil", method: :get, icon: "edit_profile"},
      %{path: "/recuperar_senha/:token", label: "Alterar Senha", method: :get, icon: "lock"},
      %{path: "/app/desconectar", label: "Sair", method: :delete, icon: "logout"}
    ]

  end

end
