defmodule Fuschia.Repo.Migrations.CreateCampus do
  use Ecto.Migration

  def change do
    create table(:campus, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :sigla, :string, null: false
      add :nome, :string
      add :cidade_id, references(:cidade, type: :string), null: false

      timestamps()
    end

    create unique_index(:campus, [:sigla])
    create unique_index(:campus, [:cidade_id, :sigla])
  end
end
