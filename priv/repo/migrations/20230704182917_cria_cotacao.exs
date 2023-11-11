defmodule Pescarte.Cotacoes.Repo.Migrations.CriaCotacao do
  use Ecto.Migration

  def change do
    create table(:cotacao, primary_key: false) do
      add :id, :string
      add :data, :date, null: false, primary_key: true
      add :link, :string, primary_key: true
      add :importada?, :boolean, default: false
      add :baixada?, :boolean, default: false
      add :tipo, :string, null: false
      add :fonte, references(:fonte_cotacao, column: :nome, type: :string), null: false
    end

    create unique_index(:cotacao, [:data, :link])
    create unique_index(:cotacao, [:link])
    create index(:cotacao, [:fonte])
  end
end
