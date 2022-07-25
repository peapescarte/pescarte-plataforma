defmodule Fuschia.Repo.Migrations.CreateMidia do
  use Ecto.Migration

  def change do
    create table("midia", primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :tipo, :string, null: false
      add :tags, {:array, :string}, null: false
      add :link, :string, null: false
      add :pesquisador_id, references(:pesquisador, type: :string)

      timestamps()
    end

    create unique_index(:midia, [:link])
    create index(:midia, [:pesquisador_id])
  end
end
