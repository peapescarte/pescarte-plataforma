defmodule Storybook.Tabela do
  use PhoenixStorybook.Story, :page

  alias PescarteWeb.DesignSystem

  def render(assigns) do
    ~H"""
      <DesignSystem.table rows={[%{check: "1-", data: "4/5/2023", tipo: "Mensal", name: "Relatório Mensal de Pesquisa de Maio", age: "Maio/2023", status: "Entregue", icone: "icon"},
                                 %{check: "2-", data: "14/4/2023", tipo: "Trimestral", name: "Relatório Trimestral de Pesquisa de Abril", age: "Junho/2023", status: "Atrasado", icone: "icon"},

                                 %{check: "3-", data: "14/5/2023", tipo: "Mensal", name: "Relatório Mensal de Pesquisa de Maio", age: "Maio/2023", status: "Atrasado", icone: "icon"},
                                 %{check: "4-", data: "10/3/2023", tipo: "Mensal", name: "Relatório Mensal de Pesquisa de Março", age: "Março/2023", status: "Entregue", icone: "download"}]}>
        <:column :let={user} label="Marcar!!">
          <%= user.check %>
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
          <%= user.icone %>
        </:column>
      </DesignSystem.table>
    """
  end
end
