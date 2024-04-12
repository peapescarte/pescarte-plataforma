defmodule Pescarte.Database.Repo.Migrations.CreateCotacoesPescados do
  use Ecto.Migration

  def change do
    create table(:cotacoes_pescados, primary_key: false) do
      add :id, :string, primary_key: true
      add :preco_minimo, :integer
      add :preco_medio, :integer
      add :preco_maximo, :integer
      add :preco_mais_comum, :integer

      add :fonte_id, references(:fonte_cotacao, type: :string), null: false
      add :cotacao_id, references(:cotacao, type: :string), null: false
      add :pescado_id, references(:pescado, type: :string), null: false
    end

    create index(:cotacoes_pescados, [:fonte_id])
    create index(:cotacoes_pescados, [:cotacao_id])
    create index(:cotacoes_pescados, [:pescado_id])
  end
end
