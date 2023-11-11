defmodule Pescarte.Cotacoes.Repo.Migrations.CriaCotacoesPescados do
  use Ecto.Migration

  def change do
    create table(:cotacoes_pescados, primary_key: false) do
      add :id, :string

      add :cotacao_data,
          references(:cotacao, column: :data, type: :date, with: [cotacao_link: :link]),
          primary_key: true

      add :cotacao_link, references(:cotacao, column: :link, type: :string)
      add :pescado_codigo, references(:pescado, column: :codigo, type: :string), primary_key: true
      add :fonte_nome, references(:fonte_cotacao, column: :nome, type: :string), primary_key: true
      add :preco_minimo, :integer
      add :preco_maximo, :integer
      add :preco_mais_comum, :integer
      add :preco_medio, :integer
    end

    create index(:cotacoes_pescados, [:cotacao_data])
    create index(:cotacoes_pescados, [:pescado_codigo])
    create index(:cotacoes_pescados, [:fonte_nome])
    create unique_index(:cotacoes_pescados, [:cotacao_data, :pescado_codigo, :fonte_nome])
  end
end
