defmodule Storybook.Tabela do
  use PhoenixStorybook.Story, :page

  alias PlataformaDigital.DesignSystem

  def render(assigns) do
    ~H"""
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
        <:column :let={user} label="Tipo">
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
