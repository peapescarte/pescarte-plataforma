defmodule PescarteWeb.DesignSystem.Navbar do
  use PescarteWeb, :component

  attr :current_path, :string, default: ""

  @doc """
  Componente de barra de navegação.
  """
  def render(assigns) do
    ~H"""
    <header id="navbar">
      <nav class="navbar">
        <DesignSystem.link navigate="/" styless>
          <img src="/images/pescarte_logo.svg" class="logo" />
        </DesignSystem.link>

        <.menu />

        <.hamburger_button />
      </nav>
      <.hamburger_menu />
    </header>
    """
  end

  defp hamburger_button(assigns) do
    ~H"""
    <div class="hamburger-button md:hidden">
      <.button
        style="link"
        click={JS.toggle(to: "#hamburger-container", in: "fade-in-scale", out: "fade-out-scale")}
      >
        <.icon name={:menu} class="text-blue-100" />
      </.button>
    </div>
    """
  end

  attr(:current_path, :string, default: "/")

  defp menu(assigns) do
    ~H"""
    <ul class="nav-menu hidden md:flex">
      <.links current_path={@current_path} />
    </ul>

    <PescarteWeb.DesignSystem.link navigate={~p"/acessar"} styless class="hidden md:flex">
      <.button style="primary" class="login-button">
        <.icon name={:log_in} class="text-white-100" />
        <.text size="base" color="text-white-100">Acessar</.text>
      </.button>
    </PescarteWeb.DesignSystem.link>
    """
  end

  attr(:current_path, :string, default: "/")

  defp hamburger_menu(assigns) do
    ~H"""
    <div id="hamburger-container" class="hidden hamburger-container">
      <ul class="nav-menu md:flex">
        <.links current_path={@current_path} />
      </ul>

      <PescarteWeb.DesignSystem.link navigate={~p"/acessar"} styless class="md:flex">
        <.button style="link" class="login-button">
          <.text size="h4" color="text-blue-100">Acessar</.text>
        </.button>
      </PescarteWeb.DesignSystem.link>
    </div>
    """
  end

  attr(:current_path, :string, default: "/")

  defp links(assigns) do
    ~H"""
    <.navlink label="Sobre" navigate={~p"/sobre"} current_path={@current_path} />
    <.navlink label="Equipes" navigate={~p"/equipes"} current_path={@current_path} />
    <.navlink label="Sedes" navigate={~p"/sedes"} current_path={@current_path} />
    <.navlink label="Cooperativas" navigate={~p"/cooperativas"} current_path={@current_path} />
    <.navlink label="Contato" navigate={~p"/contato"} current_path={@current_path} />
    """
  end

  attr(:label, :string, required: true)
  attr(:navigate, :string, default: "/")
  attr(:current_path, :string, default: "/")

  defp navlink(assigns) do
    ~H"""
    <DesignSystem.link navigate={@navigate}>
      <li class={["nav-link ", if(@current_path == @navigate, do: "active")]} aria-expanded="false">
        <.text size="h4" color="text-blue-100" class="flex" style="gap: 8px;">
          <%= @label %>
        </.text>
      </li>
    </DesignSystem.link>
    """
  end
end
