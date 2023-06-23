defmodule Pescarte.Repo.Migrations.CriaTag do
  use Ecto.Migration

  def up do
    create table(:tag, primary_key: false) do
      add :etiqueta, :string, null: false, primary_key: true
      add :id_publico, :string

      add :categoria_nome, references(:categoria, column: :nome, type: :string), null: false

      timestamps()
    end

    create index(:tag, [:categoria_nome])

    alter table(:midia) do
      remove :tags
    end
  end

  def down do
    drop_if_exists table(:tag)
    drop_if_exists index(:tag, [:categoria_nome])

    alter table(:midia) do
      add :tags, {:array, :string}, null: false
    end
  end
end
