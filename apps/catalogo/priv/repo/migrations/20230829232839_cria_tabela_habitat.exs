defmodule Catalogo.Repo.Migrations.CriaTabelaHabitat do
  use Ecto.Migration

  def change do
    create table(:habitat, primary_key: false) do
      add :nome, :string, null: false, primary_key: true

      timestamps()
    end
  end
end
