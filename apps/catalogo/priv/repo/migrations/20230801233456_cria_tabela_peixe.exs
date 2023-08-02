defmodule Catalogo.Repo.Migrations.CriaTabelaPeixe do
  use Ecto.Migration

  def change do
    create table(:peixe, primary_key: false) do
      add :nome_cientifico, :string, primary_key: true
      add :nativo?, :boolean, null: false
      add :link_imagem, :string, null: false

      timestamps()
    end
  end
end
