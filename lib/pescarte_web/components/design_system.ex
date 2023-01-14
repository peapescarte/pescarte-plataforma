defmodule PescarteWeb.DesignSystem do
  @moduledoc false

  use PescarteWeb, :verified_routes
  use Phoenix.Component

  import Phoenix.LiveView.HTMLEngine, only: [component: 3]

  @doc """

  """
  def footer(assigns) do
    ~H"""
    <footer class="footer footer-center p-4 bg-white">
      <img src={~p"/images/footer_logos.svg"} alt={footer_alt_text()} class="w-3/5" />
    </footer>
    """
  end

  defp footer_alt_text do
    """
    Bloco de logos das instiuições relacionadas
    ao projeto Pescarte: IPEAD; UENF; Petrobras;
    e Ibama.
    """
  end

  @doc """
  """
  attr :conn, :any
  attr :hidden?, :boolean, default: true

  def navbar(assigns) do
    ~H"""
    <nav class="navbar bg-white w-full">
      <div class="navbar-start p-1 w-3/4 flex justify-between lg:hidden">
        <div class="dropdown">
          <label tabindex="0">
            <!-- hamburguer icon -->
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-12 w-12"
              fill="none"
              viewBox="0 0 24 24"
              stroke="#F8961E"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h8m-8 6h16"
              />
            </svg>
          </label>
          <ul
            tabindex="0"
            class="menu menu-compact dropdown-content dropdown-left mt-3 p-2 shadow bg-white rounded-box w-52"
          >
            <.menu_links current_user={@conn.assigns.current_user} path={@conn.path_info} />
          </ul>
        </div>
        <.menu_logo hidden?={@hidden?} />
      </div>
      <div class="navbar-center container hidden lg:flex lg:justify-center">
        <ul class="menu menu-horizontal p-0">
          <.menu_logo hidden?={false} />
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
        class={["mt-3", get_hidden_style(@hidden?)]}
        src={~p"/images/pescarte_logo.svg"}
        alt="Logo completo do projeto com os dez peixinhos e nome"
        width="150"
      />
    </figure>
    """
  end

  defp get_hidden_style(true), do: "lg:hidden"
  defp get_hidden_style(false), do: ""

  attr :path, :string
  attr :method, :string, default: "get"
  attr :current?, :boolean, default: false
  attr :label, :string

  slot :inner_block, required: true

  defp menu_item(assigns) do
    ~H"""
    <li class="menu-item">
      <.link navigate={@path} method={@method} class={@current? && "current"}>
        <%= render_slot(@inner_block) %>
        <%= @label %>
      </.link>
    </li>
    """
  end

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
      <.menu_item
        path={item.path}
        label={item.label}
        method={item.method}
        current?={is_current_path?(@conn, item.path)}
      >
        <%= component(item.icon, [], caller()) %>
      </.menu_item>
    <% end %>
    """
  end

  attr :path, :string

  defp guest_menu(assigns) do
    ~H"""
    <%= for item <- guest_menu_items() do %>
      <.menu_item
        path={item.path}
        label={item.label}
        method={item.method}
        current?={is_current_path?(@path, item.path)}
      >
        <%= component(item.icon, [], caller()) %>
      </.menu_item>
    <% end %>
    <.link type="button" navigate={~p"/acessar"}>
      Acessar
    </.link>
    """
  end

  defp caller do
    {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
  end

  defp is_current_path?(path_info, to) do
    # get from %Plug.Conn{}
    path = Enum.join(path_info, "/")

    to =~ path
  end

  defp guest_menu_items do
    [
      %{path: "/", label: "Home", method: :get, icon: &Lucideicons.home/1},
      %{path: "/pesquisa", label: "Pesquisa", method: :get, icon: &Lucideicons.file/1},
      %{path: "/biblioteca", label: "Biblioteca", method: :get, icon: &Lucideicons.book/1},
      %{
        path: "/agenda_socioambiental",
        label: "Agenda Socioambiental",
        method: :get,
        icon: &Lucideicons.calendar/1
      }
    ]
  end

  defp authenticated_menu_items do
    [
      %{path: "/app/dashboard", label: "Home", method: :get, icon: &Lucideicons.home/1},
      %{
        path: "/app/pesquisadores",
        label: "Pesquisadores",
        method: :get,
        icon: &Lucideicons.users/1
      },
      %{path: "/app/relatorios", label: "Relatórios", method: :get, icon: &Lucideicons.file/1},
      %{path: "/app/agenda", label: "Agenda", method: :get, icon: &Lucideicons.calendar/1},
      %{path: "/app/mensagens", label: "Mensagens", method: :get, icon: &Lucideicons.mail/1}
    ]
  end
end
