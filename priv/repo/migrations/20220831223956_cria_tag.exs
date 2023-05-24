defmodule Pescarte.Repo.Migrations.CriaTag do
  use Ecto.Migration

  def up do
    create table(:tag) do
      add :etiqueta, :string, null: false
      add :id_publico, :string

      add :categoria_id, references(:categoria), null: false

      timestamps()
    end

    create unique_index(:tag, [:etiqueta])
    create index(:tag, [:categoria_id])

    alter table(:midia) do
      remove :tags
    end
  end

  def down do
    drop_if_exists table(:tag)
    drop_if_exists unique_index(:tag, [:etiqueta])
    drop_if_exists index(:tag, [:categoria_id])

    alter table(:midia) do
      add :tags, {:array, :string}, null: false
    end
  end
end
