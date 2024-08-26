defmodule PescarteWeb.DesignSystem.Navbar do
  use PescarteWeb, :component

  alias Phoenix.LiveView.JS

  attr :current_path, :string, default: ""

  @doc """
  Componente de barra de navegação.
  """
  def render(assigns) do
    ~H"""
    <header id="navbar">
      <nav class="navbar">
        <DesignSystem.link navigate="/" styless>
          <img src="/images/pescarte_logo.svg" class="logo hidden lg:block" />
          <img src="/images/icon_logo.svg" class="logo md:hidden" />
        </DesignSystem.link>

        <.hamburger_button />

        <ul class="nav-menu">
          <.navlink label="Sobre" navigate={~p"/sobre"} current_path={@current_path} />
          <.navlink label="Equipes" navigate={~p"/equipes"} current_path={@current_path} />
          <.navlink label="Sedes" navigate={~p"/sedes"} current_path={@current_path} />
          <.navlink label="Cooperativas" navigate={~p"/cooperativas"} current_path={@current_path} />
          <.navlink label="Contato" navigate={~p"/contato"} current_path={@current_path} />
        </ul>

        <PescarteWeb.DesignSystem.link navigate={~p"/acessar"} styless>
          <.button style="primary" class="login-button">
            <Lucideicons.log_in class="text-white-100" />
            <.text size="base" color="text-white-100">Acessar</.text>
          </.button>
        </PescarteWeb.DesignSystem.link>
      </nav>
      <.open_hamburger />
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

  defp hamburger_button(assigns) do
    ~H"""
    <div class="md:hidden">
      <button phx.click={show_hamburger()}>
        <Lucideicons.menu class="text-blue-100" />
      </button>
    </div>
    """
  end

  defp open_hamburger(assigns) do
    ~H"""
    <div id="hamburger-container" class="hidden relative z-50">
      <div id="hamburger-backdrop" class="fixed inset-0 bg-zinc-50/90 transition-opacity"></div>
      <nav
        id="hamburger-content"
        class="fixed top-0 left-0 bottom-0 flex flex-col grow justify-between w-3/4 max-w-sm py-6 bg-white border-r overflow-y-auto"
      >
        <div>
          <div class="flex items-center mb-4 place-content-between mx-4 border-b-zinc-200">
            <div class="flex items-center gap-4">
              <p class="bg-brand/5 text-brand rounded-xl px-2 font-medium leading-6">
                Hamburger
              </p>
            </div>
            <button class="navbar-close" phx-click={hide_hamburger()}></button>
          </div>
          <div>
            <ul></ul>
            <li class="block px-6 py-2 text-sm font-semibold hover:bg-gray-200" phx-click="/">
              <.navlink label="Sobre" navigate={~p"/sobre"} current_path="/" />
              <.navlink label="Equipes" navigate={~p"/equipes"} current_path="/" />
            </li>
          </div>
        </div>
      </nav>
    </div>
    """
  end

  defp show_hamburger(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#hamburger-content",
      transition:
        {"transition-all transform ease-in-out duration-300", "-translate-x-3/4", "translate-x-0"},
      time: 300,
      display: "flex"
    )
    |> JS.show(
      to: "#hamburger-backdrop",
      transition:
        {"transition-all transform ease-in-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "#hamburger-container",
      time: 300
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp hide_hamburger(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#hamburger-backdrop",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "#hamburger-content",
      transition:
        {"transition-all transform ease-in duration-200", "translate-x-0", "-translate-x-3/4"}
    )
    |> JS.hide(to: "#hamburger-container", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
  end
end
