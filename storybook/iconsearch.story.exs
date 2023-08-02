defmodule Storybook.Iconsearch do
  use PhoenixStorybook.Story, :page

  alias PlataformaDigital.DesignSystem

  def render(assigns) do
    ~H"""
    <div class="search">
      <fieldset class="search-input">
        <div class="search-icon">
          <Lucideicons.search />
        </div>
        <input
        id="txtBusca"
        placeholder="Faça uma pesquisa..."
        phx-keyup="search"
        phx-debounce={300}
        />
      </fieldset>

      <div class="links-item">
       <DesignSystem.button class="icon-button" style="secondary">
       <Lucideicons.filter class="text-white-100" />
        <DesignSystem.text size="sm" color="text-white-100">Filtro</DesignSystem.text>
       </DesignSystem.button>
      </div>

      <div class="links-item">
       <DesignSystem.button class="icon-button" style="primary" submit>
        <Lucideicons.book class="text-white-100" />
        <DesignSystem.text size="sm" color="text-white-100">Preencher Relatório</DesignSystem.text>
       </DesignSystem.button>
      </div>

      <div class="links-item">
       <DesignSystem.button class="icon-button" style="secondary">
        <Lucideicons.files class="text-white-100" />
        <DesignSystem.text size="sm" color="text-white-100">Compilar</DesignSystem.text>
       </DesignSystem.button>
      </div>
    </div>
    """
  end
end
