defmodule Pescarte.Database.Repo.Migrations.CreateCotacao do
  use Ecto.Migration

  def change do
    create table(:cotacao, primary_key: false) do
      add :id, :string, primary_key: true
      add :data, :date, null: false
      add :link, :string, null: false
      add :importada?, :boolean, default: false
      add :baixada?, :boolean, default: false
      add :tipo, :string, null: false
      add :fonte_id, references(:fonte_cotacao, type: :string), null: false

      timestamps()
    end

    create index(:cotacao, [:fonte_id])
  end
end
