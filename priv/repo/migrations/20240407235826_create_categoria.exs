defmodule Pescarte.Database.Repo.Migrations.CreateCategoria do
  use Ecto.Migration

  def change do
    create table(:categoria, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome, :string, null: false

      timestamps()
    end
  end
end
