defmodule Database.Repo.Migrations.CriaCotacao do
  use Ecto.Migration

  def change do
    create table(:cotacao, primary_key: false) do
      add :id, :string
      add :data, :date, primary_key: true, null: false
      add :link, :string
      add :importada?, :boolean, default: false

      add :fonte, references(:fonte_cotacao, column: :nome, type: :string),
        primary_key: true,
        null: false
    end

    create index(:cotacao, [:fonte])
    create unique_index(:cotacao, [:data])
  end
end
