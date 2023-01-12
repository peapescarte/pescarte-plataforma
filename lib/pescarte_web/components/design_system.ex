defmodule PescarteWeb.DesignSystem do
  @moduledoc false

  use PescarteWeb, :verified_routes
  use Phoenix.Component

  import PescarteWeb.CoreComponents, only: [button: 1]

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
  attr :name, :string

  def icon(assigns) do
    ~H"""
    <figure>
      <img
        role="img"
        src={build_icon_path(@name)}
        alt={get_alt_text(@name)}
        class={["icon", "icon-#{@name}"]}
      />
    </figure>
    """
  end

  defp build_icon_path(icon_name) do
    "/icons/#{icon_name}.svg"
  end

  defp get_alt_text("accounts") do
    "Ícone que representa duas ou mais contas"
  end

  defp get_alt_text("agenda") do
    "Ícone que representa um calendário"
  end

  defp get_alt_text("book") do
    "Ícone que representa um livro aberto"
  end

  defp get_alt_text("compilation") do
    "Ícone que representa uma compilação de arquivos"
  end

  defp get_alt_text("file") do
    "Ícone que representa um arquivo"
  end

  defp get_alt_text("filter") do
    "Ícone que representa um filtro"
  end

  defp get_alt_text("home") do
    "Ícone que representa uma casa"
  end

  defp get_alt_text("image") do
    "Ícone que representa uma imagem"
  end

  defp get_alt_text("login") do
    "Ícone que representa uma seta para entrada"
  end

  defp get_alt_text("message") do
    "Ícone que representa uma mensagem"
  end

  defp get_alt_text("new_account") do
    "Ícone que representa uma nova conta a ser criada"
  end

  defp get_alt_text("new_file") do
    "Ícone que representa um novo arquivo a ser criado"
  end

  defp get_alt_text("search") do
    "Ícone que representa uma lupa para pesquisa"
  end

  @doc """
  """
  attr :conn, :any
  attr :hidden?, :boolean

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
            <.menu_links {@conn} />
          </ul>
        </div>
        <.menu_logo {@hidden?} />
      </div>
      <div class="navbar-center container hidden lg:flex lg:justify-center">
        <ul class="menu menu-horizontal p-0">
          <.menu_logo hidden?={false} />
          <.menu_links {@conn} />
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
  attr :method, :atom
  attr :current?, :boolean
  attr :label, :string
  attr :icon, :string, default: nil

  defp menu_item(assigns) do
    ~H"""
    <li class="menu-item">
      <.link to: @path, method: @method, active: @current? do %>
        <.icon :if={@icon} name={@icon} />
        <%= @label %>
      </.link>
    </li>
    """
  end

  attr :conn, :any

  defp menu_links(assigns) do
    ~H"""
    <%= if @conn.assigns.current_user do %>
      <%= for item <- authenticated_menu() do %>
        <.menu_item
          icon={item.icon}
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
      <.button label="Acessar" to="/acessar" />
    <% else %>
      <%= for item <- guest_menu() do %>
        <.menu_item
          icon={item.icon}
          path={item.path}
          label={item.label}
          method={item.method}
          current?={is_current_path?(@conn, item.path)}
        />
      <% end %>
      <.button label="Acessar" to="/acessar" icon="login" />
    <% end %>
    """
  end

  defp is_current_path?(%Plug.Conn{} = conn, to) do
    path = Enum.join(conn.path_info, "/")

    to =~ path
  end

  defp guest_menu do
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

  defp authenticated_menu do
    [
      %{path: "/app/dashboard", label: "Home", method: :get, icon: "home"},
      %{path: "/app/pesquisadores", label: "Pesquisadores", method: :get, icon: "accounts"},
      %{path: "/app/relatorios", label: "Relatórios", method: :get, icon: "file"},
      %{path: "/app/agenda", label: "Agenda", method: :get, icon: "agenda"},
      %{path: "/app/mensagens", label: "Mensagens", method: :get, icon: "message"}
    ]
  end
end
