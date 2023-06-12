defmodule Storybook.Botaofiltro do
  use PhoenixStorybook.Story, :page

  alias PescarteWeb.DesignSystem


  # Declare an optional tab-based navigation in your page:
  def navigation do
    [
      {:pesquisa, "Faça uma pesquisa", {:fa, "search", :thin}},
      {:filtro, "Filtro", {:fa, "download", :thin} },
      {:novo, "Novo Relatório", {:fa, "box-check", :thin}},
      {:compila, "Compilar", {:fa, "icons", :thin}}
    ]
  end

  def render(assigns) do
    ~H"""
    <div class="navigation">
      <div class="search">
        <DesignSystem.button style="primary" submit>
        <DesignSystem.text_input type="text" name="search" value="" placeholder="Faça uma pesquisa" />
        </DesignSystem.button>

        <DesignSystem.button style="primary" submit> <Lucideicons.search class="text-blue-100" />
        </DesignSystem.button>
      </div>

      <div class="search">
        <DesignSystem.button style="primary" submit>
        <DesignSystem.text_input type="text" name="search" value="" placeholder="Faça uma pesquisa" />
        </DesignSystem.button>

        <button phx-click="search"><i class="fas fa-search"></i> Faça uma pesquisa</button>

        <DesignSystem.button style=" "><i class="fas fa-search"></i> Pesquisa por tipo </DesignSystem.button>
      </div>
    </div>

    <div class="navigation">
      <div class="search">
        <DesignSystem.button style="primary" submit>
          <DesignSystem.text size="sm">Compilar !!!!</DesignSystem.text>
        </DesignSystem.button>

        <Lucideicons.files class="text-blue-100" />

        <DesignSystem.button style="primary" submit> <Lucideicons.download class="text-blue-100" />
          <DesignSystem.text size="sm">Baixar</DesignSystem.text>
        </DesignSystem.button>
      </div>
    </div>



    <div class="links">
      <div class="links-item">
        <DesignSystem.button class="button-icon" style="primary" submit>
          <DesignSystem.text size="sm">Compilar !!!!</DesignSystem.text>
        </DesignSystem.button> <Lucideicons.files class="text-blue-100" />
      </div>

      <div class="links-item">
        <DesignSystem.link >
          <DesignSystem.text size="sm">Compilar 2</DesignSystem.text>
        </DesignSystem.link>
      </div>

      <div class="links-item">
        <DesignSystem.button style="primary" submit> <Lucideicons.download class="text-blue-100" />
        <DesignSystem.text size="sm">Baixar</DesignSystem.text>
        </DesignSystem.button>
      </div>

      <div class="links-item">
       <DesignSystem.button class="icon-button" style="primary" submit>
       <Lucideicons.filter class="text-blue-100" />
        <DesignSystem.text size="sm" bg="bg-blue-100">Filtro</DesignSystem.text>
       </DesignSystem.button>
      </div>

      <div class="links-item">
       <DesignSystem.button class="icon-button" style="primary" submit>
        <Lucideicons.files class="text-blue-100" />
        <DesignSystem.text size="sm" color="text-blue-100">Novo Relatório</DesignSystem.text>
       </DesignSystem.button>
      </div>
    </div>
    """
  end
  end
