defmodule Catalogo.Repo.Migrations.CriaTabelaApetrechoDePesca do
  use Ecto.Migration

  def change do
    create table(:apetrecho_pesca, primary_key: false) do
      add :nome, :string, primary_key: true
      add :id_publico, :string, null: false

      timestamps()
    end
  end
end
