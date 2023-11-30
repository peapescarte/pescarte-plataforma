defmodule Catalogo.Repo.Migrations.CriaTabelaHabitat do
  use Ecto.Migration

  def change do
    create table(:habitat, primary_key: false) do
      add :nome, :string, null: false, primary_key: true
      add :id_publico, :string, null: false

      timestamps()
    end
  end
end
