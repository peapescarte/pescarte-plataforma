defmodule Storybook.Botaofiltro do
  use PhoenixStorybook.Story, :page

  alias PescarteWeb.DesignSystem

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


    <DesignSystem.table rows={[%{ data: "4/5/2023", tipo: "Mensal", name: "Relatório Mensal - Maio", age: "Maio/2023", status: "Entregue"},
                                 %{ data: "14/4/2023", tipo: "Trimestral", name: "Relatório Trimestral - Abril", age: "Junho/2023", status: "Atrasado"},
                                 %{ data: "14/5/2023", tipo: "Mensal", name: "Relatório Mensal - Maio", age: "Maio/2023", status: "Atrasado"},
                                 %{ data: "10/3/2023", tipo: "Mensal", name: "Relatório Mensal - Março", age: "Março/2023", status: "Entregue"}]}>
        <:column :let={user} label="  " >
          <DesignSystem.checkbox name="check" id="usuario"/>
        </:column>
        <:column :let={user} label="Data">
          <%= user.data %>
        </:column>
        <:column :let={user} label="Tipo" class="linhas">
          <%= user.tipo %>
        </:column>
        <:column :let={user} label="Mês/Ano">
          <%= user.age %>
        </:column>
        <:column :let={user} label="Nome">
          <%= user.name %>
        </:column>
        <:column :let={user} label="Status">
          <%= user.status %>
        </:column>
        <:column :let={user} label="Baixar">
          <Lucideicons.download />
        </:column>
      </DesignSystem.table>


    """
  end
end
