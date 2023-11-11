defmodule Pescarte.ModuloPesquisa.Repo.Migrations.CriaMidia do
  use Ecto.Migration

  def change do
    create table(:midia, primary_key: false) do
      add :id_publico, :string
      add :tipo, :string, null: false
      add :tags, {:array, :string}, null: false
      add :link, :string, null: false, primary_key: true

      add :autor_id, references(:usuario, column: :id_publico, type: :string), null: false

      timestamps()
    end

    create unique_index(:midia, [:link])
    create index(:midia, [:autor_id])
  end
end
