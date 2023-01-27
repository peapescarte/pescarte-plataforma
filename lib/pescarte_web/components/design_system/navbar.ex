defmodule PescarteWeb.DesignSystem.NavBar do
  use PescarteWeb, :verified_routes
  use Phoenix.Component

  attr(:conn, :any)
  attr(:path, :string)
  attr(:hidden?, :boolean, default: true)

  def navbar(assigns) do
    ~H"""
    <nav class="navbar">
      <div class="mobile">
        <div class="dropdown">
          <label tabindex="0" class="btn btn-ghost">
            <Lucideicons.menu stroke="#FF6E00" />
          </label>
          <ul tabindex="0">
            <.menu_links current_user={@conn.assigns.current_user} path={@conn.path_info} />
          </ul>
        </div>
        <li class="btn btn-ghost">
          <.menu_logo hidden?={@hidden?} />
        </li>
      </div>
      <div class="desktop">
        <ul>
          <li class="menu-logo"><.menu_logo hidden?={false} /></li>
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
        class={[@hidden? && "lg:hidden"]}
        src={~p"/images/pescarte_logo.svg"}
        alt="Logo completo do projeto com os dez peixinhos e nome"
      />
    </figure>
    """
  end

  attr(:path, :string)
  attr(:method, :string, default: "get")
  attr(:current?, :boolean, default: false)

  slot(:inner_block, required: true)

  defp menu_item(assigns) do
    ~H"""
    <li class="menu-item">
      <.link navigate={@path} method={@method}>
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end

  attr(:path, :string)
  attr(:current_user, Pescarte.Accounts.Models.User, default: nil)

  # Utiliza a função `Phoenix.LivewView.HTMLEngine.component/1`
  # manualmente para renderizar componentes dinâmicamente
  # dentro do `for/1`
  defp menu_links(assigns) do
    ~H"""
    <.authenticated_menu :if={@current_user} path={@path} />
    <.guest_menu :if={!@current_user} path={@path} />
    """
  end

  attr(:path, :string)

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

  attr(:path, :string)

  defp guest_menu(assigns) do
    ~H"""
    <%= for item <- guest_menu_items() do %>
      <.menu_item path={item.path} method={item.method} current?={is_current_path?(@path, item.path)}>
        <.icon name={item.icon} />
        <%= item.label %>
      </.menu_item>
    <% end %>
    <.link href={~p"/acessar"} class="btn btn-primary">
      <Lucideicons.log_in /> Acessar
    </.link>
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

  attr(:name, :atom, required: true)

  defp icon(assigns) do
    apply(Lucideicons, assigns.name, [assigns])
  end
end
