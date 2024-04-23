defmodule PescarteWeb.DesignSystem.Navbar do
  use PescarteWeb, :component

  @navdropdown_items %{
    institucional: [
      %{
        icon: :microscope,
        title: "Núcleo",
        description: "Nossos núcleos de pesquisa pesquisa pesquisa pesquisa pesquisa pesquisa.",
        href: "/nucleos"
      },
      %{
        icon: :building,
        title: "Municípios",
        description: "O projeto está presente em 00 municípios do estado do Rio de Janeiro.",
        href: "/municipios"
      },
      %{
        icon: :files,
        title: "Biblioteca",
        description:
          "Repositório de mídias e documentos de pesquisa disponibilizados pelo projeto.",
        href: "/biblioteca"
      }
    ],
    pesquisa: [
      %{
        icon: :file_search,
        title: "Linhas",
        description: "Nossos núcleos de pesquisa pesquisa pesquisa pesquisa pesquisa pesquisa.",
        href: "/linhas-pesquisa"
      },
      %{
        icon: :user,
        title: "Pesquisador",
        description: "O projeto está presente em 00 municípios do estado do Rio de Janeiro.",
        href: "/pesquisadores"
      },
      %{
        icon: :newspaper,
        title: "Publicações",
        description:
          "Repositório de mídias e documentos de pesquisa disponibilizados pelo projeto.",
        href: "/publicacoes"
      }
    ],
    pesca: [
      %{
        icon: :briefcase,
        title: "Empreendedor",
        description: "Nossos núcleos de pesquisa pesquisa pesquisa pesquisa pesquisa pesquisa.",
        href: "/empreendedor"
      },
      %{
        icon: :trees,
        title: "Cooperativa",
        description: "O projeto está presente em 00 municípios do estado do Rio de Janeiro.",
        href: "/cooperativas"
      },
      %{
        icon: :fish,
        title: "Pescadores",
        description:
          "Repositório de mídias e documentos de pesquisa disponibilizados pelo projeto.",
        href: "/pescadores"
      },
      %{
        icon: :users,
        title: "Comunidades",
        description:
          "Repositório de mídias e documentos de pesquisa disponibilizados pelo projeto.",
        href: "/comunidades"
      }
    ]
  }

  @doc """
  Componente de barra de navegação.
  """
  def render(assigns) do
    assigns = assign(assigns, :dropdown_items, @navdropdown_items)

    ~H"""
    <header id="navbar">
      <nav class="navbar">
        <DesignSystem.link navigate="/" styless>
          <img src="/images/pescarte_logo.svg" class="logo" />
        </DesignSystem.link>
        <ul class="nav-menu">
          <.navlink label="Institucional">
            <:item
              :for={item <- @dropdown_items.institucional}
              title={item.title}
              icon={item.icon}
              href={item.href}
            >
              <%= item.description %>
            </:item>
            icon={item.icon}
          </.navlink>

          <.navlink label="Pesquisa">
            <:item
              :for={item <- @dropdown_items.pesquisa}
              title={item.title}
              icon={item.icon}
              href={item.href}
            >
              <%= item.description %>
            </:item>
            icon={item.icon}
          </.navlink>

          <.navlink label="Pesca">
            <:item
              :for={item <- @dropdown_items.pesca}
              title={item.title}
              icon={item.icon}
              href={item.href}
            >
              <%= item.description %>
            </:item>
            icon={item.icon}
          </.navlink>
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

  attr :label, :string, required: true

  slot :item do
    attr :icon, :atom
    attr :title, :string
    attr :href, :string
  end

  defp navlink(assigns) do
    ~H"""
    <li class="nav-link" aria-expanded="false" data-component="navbar-dropdown">
      <.text size="h4" color="text-blue-100" class="flex" style="gap: 8px;">
        <%= @label %>
        <Lucideicons.chevron_down />
      </.text>
      <ul class="nav-dropdown invisible">
        <Phoenix.Component.link :for={item <- @item} navigate={item.href}>
          <span class="flex justify-beetween items-center" style="gap: 12px; margin-bottom: 9px;">
            <.icon name={item.icon} class="text-blue-100" />
            <.text color="text-blue-100" size="lg"><%= item.title %></.text>
          </span>
          <.text color="text-black-80" size="sm" style="margin-left: 36px;">
            <%= render_slot(item) %>
          </.text>
        </Phoenix.Component.link>
      </ul>
    </li>
    """
  end
end
