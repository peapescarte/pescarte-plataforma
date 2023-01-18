defmodule PescarteWeb.DesignSystem.NavBar do
  use PescarteWeb, :verified_routes
  use Phoenix.Component

  alias PescarteWeb.DesignSystem

  attr :conn, :any
  attr :path, :string
  attr :hidden?, :boolean, default: true

  def navbar(assigns) do
    ~H"""
    <nav class="navbar w-full bg-white-100">
      <div class="navbar-start flex justify-between">
        <div class="dropdown">
          <label tabindex="0" class="btn btn-ghost lg:hidden">
            <Lucideicons.menu stroke="#FF6E00" />
          </label>
          <ul
            tabindex="0"
            class="menu menu-compact dropdown-content dropdown-left mt-3 p-2 shadow bg-white rounded-box w-52"
          >
            <.menu_links current_user={@conn.assigns.current_user} path={@conn.path_info} />
          </ul>
        </div>
        <li class="btn btn-ghost"><.menu_logo hidden?={@hidden?} /></li>
      </div>
      <div class="navbar-center container hidden lg:flex lg:justify-center">
        <ul class="menu menu-horizontal p-0">
          <li class="menu-item"><.menu_logo hidden?={false} /></li>
          <.menu_links current_user={@conn.assigns.current_user} path={@conn.path_info} />
        </ul>
      </div>
    </nav>
    """
  end

  defp menu_logo(assigns) do
    ~H"""
    <figure>
      <img
        class={["mt-3", @hidden? && "lg:hidden"]}
        src={~p"/images/pescarte_logo.svg"}
        alt="Logo completo do projeto com os dez peixinhos e nome"
        width="150"
      />
    </figure>
    """
  end

  attr :path, :string
  attr :method, :string, default: "get"
  attr :current?, :boolean, default: false

  slot :inner_block, required: true

  defp menu_item(assigns) do
    ~H"""
    <li class="menu-item">
      <.link navigate={@path} method={@method} class={menu_item_class(@current?)}>
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end

  defp menu_item_class(current?) do
    """
    hover:text-white hover:bg-blue-60 btn btn-primary
    #{(current? && "bg-blue-100 text-white") || "text-blue-100"}
    """
  end

  attr :path, :string
  attr :current_user, Pescarte.Accounts.Models.User, default: nil

  # Utiliza a função `Phoenix.LivewView.HTMLEngine.component/1`
  # manualmente para renderizar componentes dinâmicamente
  # dentro do `for/1`
  defp menu_links(assigns) do
    ~H"""
    <.authenticated_menu :if={@current_user} path={@path} />
    <.guest_menu :if={!@current_user} path={@path} />
    """
  end

  attr :path, :string

  defp authenticated_menu(assigns) do
    ~H"""
    <%= for item <- authenticated_menu_items() do %>
      <.menu_item path={item.path} method={item.method} current?={is_current_path?(@path, item.path)}>
        <.icon name={item.icon} />
        <%= item.label %>
      </.menu_item>
    <% end %>
    """
  end

  attr :path, :string

  defp guest_menu(assigns) do
    ~H"""
    <%= for item <- guest_menu_items() do %>
      <.menu_item path={item.path} method={item.method} current?={is_current_path?(@path, item.path)}>
        <.icon name={item.icon} />
        <%= item.label %>
      </.menu_item>
    <% end %>
    <DesignSystem.button type="button" style="primary">
      <Lucideicons.log_in /> Acessar
    </DesignSystem.button>
    """
  end

  defp is_current_path?([], "/"), do: true

  defp is_current_path?([], _to), do: false

  defp is_current_path?(path_info, to) do
    # get from %Plug.Conn{}
    path = Enum.join(path_info, "/")

    to =~ path
  end

  defp guest_menu_items do
    [
      %{path: "/", label: "Home", method: :get, icon: :home},
      %{path: "/pesquisa", label: "Pesquisa", method: :get, icon: :file},
      %{path: "/biblioteca", label: "Biblioteca", method: :get, icon: :book},
      %{
        path: "/agenda_socioambiental",
        label: "Agenda Socioambiental",
        method: :get,
        icon: :calendar
      }
    ]
  end

  defp authenticated_menu_items do
    [
      %{path: "/app/dashboard", label: "Home", method: :get, icon: :home},
      %{
        path: "/app/pesquisadores",
        label: "Pesquisadores",
        method: :get,
        icon: :users
      },
      %{path: "/app/relatorios", label: "Relatórios", method: :get, icon: :file},
      %{path: "/app/agenda", label: "Agenda", method: :get, icon: :calendar},
      %{path: "/app/mensagens", label: "Mensagens", method: :get, icon: :mail}
    ]
  end

  attr :name, :atom, required: true

  defp icon(assigns) do
    apply(Lucideicons, assigns.name, [assigns])
  end
end
