defmodule PescarteWeb.DesignSystem.NavBar do
  use PescarteWeb, :verified_routes
  use Phoenix.Component

  alias Pescarte.Domains.Accounts.Models.User
  alias PescarteWeb.DesignSystem

  attr(:current_user, User, default: nil)
  attr(:path, :string)

  def navbar(assigns) do
    ~H"""
    <nav class={["navbar", @current_user && "authenticated"]}>
      <div class="desktop">
        <ul>
          <li class="menu-logo">
            <.menu_logo />
          </li>
          <.guest_menu :if={!@current_user} />
          <.authenticated_menu :if={@current_user} path={@path} />
        </ul>
        <div class="user-info">
          <%= if @current_user && @current_user.pesquisador.avatar do %>
            <img class="avatar" src={@current_user.pesquisador.avatar} />
          <% else %>
            <Lucideicons.user :if={@current_user} />
          <% end %>
          <DesignSystem.text :if={@current_user} size="base" color="black-80" text_case="capitalize">
            <%= @current_user.first_name %>
          </DesignSystem.text>
        </div>
      </div>
    </nav>
    """
  end

  defp menu_logo(assigns) do
    ~H"""
    <figure>
      <img
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
  slot(:icon, required: true)

  defp menu_item(assigns) do
    ~H"""
    <li class="menu-item">
      <%= render_slot(@icon) %>
      <.link navigate={@path} method={@method}>
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end

  # Utiliza a função `Phoenix.LivewView.HTMLEngine.component/1`
  # manualmente para renderizar componentes dinâmicamente
  # dentro do `for/1`
  defp guest_menu(assigns) do
    ~H"""
    <%= for item <- guest_menu_items() do %>
      <.menu_item path={item.path} method={item.method}>
        <:icon>
          <Lucideicons.home />
        </:icon>
        <%= item.label %>
      </.menu_item>
    <% end %>
    <.link href={~p"/acessar"} class="btn btn-primary">
      <Lucideicons.log_in /> Acessar
    </.link>
    """
  end

  attr(:path, :string)

  defp authenticated_menu(assigns) do
    ~H"""
    <%= for item <- authenticated_menu_items() do %>
      <.menu_item path={item.path} method={item.method} current?={current_path?(@path, item.path)}>
        <:icon>
          <.icon name={item.icon} />
        </:icon>
        <%= item.label %>
      </.menu_item>
    <% end %>
    """
  end

  defp current_path?([], "/"), do: true

  defp current_path?([], _to), do: false

  defp current_path?(path_info, to) do
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
