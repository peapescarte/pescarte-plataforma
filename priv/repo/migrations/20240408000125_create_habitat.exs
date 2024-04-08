defmodule Pescarte.Database.Repo.Migrations.CreateHabitat do
  use Ecto.Migration

  def change do
    create table(:habitat, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome, :string, null: false

      timestamps()
    end
  end
end
