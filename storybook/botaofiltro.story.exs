defmodule Storybook.Botaofiltro do
  use PhoenixStorybook.Story, :page

  alias PescarteWeb.DesignSystem

  # Declare an optional tab-based navigation in your page:
  def navigation do
    [
      {:busca, "Busca por itens", {:fa, "hand-wave", :thin}},
      {:filtro, "Filtro", {:fa, "toolbox", :thin} },
      {:novo, "Novo Relatório", {:fa, "box-check", :thin}},
      {:compila, "Compilar", {:fa, "icons", :thin}}
    ]
  end
  def render(assigns) do
    ~H"""
    <DesignSystem.button style="primary">
     <Lucideicons.filter class="text-white-100" />
     <DesignSystem.text size="base" color="text-white-100">Filtros</DesignSystem.text>
    </DesignSystem.button>
    """
  end
end
