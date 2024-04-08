defmodule Pescarte.Database.Repo.Migrations.CreateCampus do
  use Ecto.Migration

  def change do
    create table(:campus, primary_key: false) do
      add :id, :string, primary_key: true
      add :acronimo, :string
      add :nome, :string, null: false
      add :nome_universidade, :string, null: false
      add :endereco, :string

      timestamps()
    end
  end
end
