defmodule Database.EscritaRepo.Migrations.CriaCotacoesPescados do
  use Ecto.Migration

  def change do
    create table:cotacoes_pescados, primary_key: false do
      add :cotacao_data, references(:cotacao, column: :data, type: :date), primary_key: true
      add :pescado_codigo, references(:pescado, column: :codigo, type: :string), primary_key: true
      add :fonte_nome, references(:fonte, column: :nome, type: :string), primary_key: true
      add :preco_minimo, :float
      add :preco_maximo, :float
      add :preco_mais_comum, :float
      add :preco_medio, :float
    end

    create index(:cotacoes_pescados, [:cotacao_data])
    create index(:cotacoes_pescados, [:pescado_codigo])
    create index(:cotacoes_pescados, [:fonte_nome])
    create unique_index(:cotacoes_pescados, [:cotacao_data, :pescado_codigo, :fonte_nome])
  end
end
