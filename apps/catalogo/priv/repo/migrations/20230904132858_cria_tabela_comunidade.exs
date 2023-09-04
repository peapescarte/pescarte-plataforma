defmodule Catalogo.Repo.Migrations.CriaTabelaComunidade do
  use Ecto.Migration

  def change do
    create table(:comunidade, primary_key: false) do
      add :nome, :string, primary_key: true
      add :descricao, :text
      add :endereco_cep, references(:endereco, column: :cep, type: :string), null: false
      add :id_publico, :string, null: false

      timestamps()
    end
  end
end
