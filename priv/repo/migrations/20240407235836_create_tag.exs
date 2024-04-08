defmodule Pescarte.Database.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tag, primary_key: false) do
      add :id, :string, primary_key: true
      add :etiqueta, :string, null: false
      add :categoria_id, references(:categoria,type: :string), null: false

      timestamps()
    end

    create index(:tag, [:categoria_id])
    create unique_index(:tag, [:etiqueta, :categoria_id])
  end
end
