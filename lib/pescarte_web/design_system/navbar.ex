defmodule PescarteWeb.DesignSystem.Navbar do
  use PescarteWeb, :component

  alias PescarteWeb.DesignSystem

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
          <.navlink label="Cooperativas" />

          <.navlink label="Sobre" />

          <.navlink label="Equipes" navigate={~p"/equipes"} />
        </ul>
        <DesignSystem.link navigate={~p"/acessar"} styless>
          <.button style="primary" class="login-button">
            <Lucideicons.log_in class="text-white-100" />
            <.text size="base" color="text-white-100">Acessar</.text>
          </.button>
        </DesignSystem.link>
      </nav>
    </header>
    """
  end

  attr :label, :string, required: true
  attr :navigate, :string, default: "/"

  defp navlink(assigns) do
    ~H"""
    <DesignSystem.link navigate={@navigate} styless>
      <li class="nav-link" aria-expanded="false">
        <.text size="h4" color="text-blue-100" class="flex" style="gap: 8px;">
          <%= @label %>
        </.text>
      </li>
    </DesignSystem.link>
    """
  end
end
