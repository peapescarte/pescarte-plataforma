defmodule Database.Repo.Migrations.CriaCotacao do
  use Ecto.Migration

  def change do
    create table(:cotacao, primary_key: false) do
      add :id, :string
      add :data, :date, null: false
      add :link, :string, primary_key: true
      add :importada?, :boolean, default: false
      add :baixada?, :boolean, default: false
      add :fonte, references(:fonte_cotacao, column: :nome, type: :string), null: false
    end

    create index(:cotacao, [:fonte])
    create index(:cotacao, [:link])
  end
end
