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
        <ul class="nav-menu">
          <.navlink label="Sobre" navigate={~p"/sobre"} current_path={@current_path} />
          <.navlink label="Equipes e Sedes" navigate={~p"/equipes"} current_path={@current_path} />
          <.navlink label="Cooperativas" navigate={~p"/cooperativas"} current_path={@current_path} />
        </ul>
        <PescarteWeb.DesignSystem.link navigate={~p"/acessar"} styless>
          <.button style="primary" class="login-button">
            <Lucideicons.log_in class="text-white-100" />
            <.text size="base" color="text-white-100">Acessar</.text>
          </.button>
        </PescarteWeb.DesignSystem.link>
      </nav>
    </header>
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
