defmodule Pescarte.Repo.Migrations.CriaMidia do
  use Ecto.Migration

  def change do
    create table("midia") do
      add :id_publico, :string
      add :tipo, :string, null: false
      add :tags, {:array, :string}, null: false
      add :link, :string, null: false

      add :autor_id, references(:usuario), null: false

      timestamps()
    end

    create unique_index(:midia, [:link])
    create index(:midia, [:autor_id])
  end
end
