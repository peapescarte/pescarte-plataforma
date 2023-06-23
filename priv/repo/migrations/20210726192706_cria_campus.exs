defmodule Pescarte.Repo.Migrations.CriaCampus do
  use Ecto.Migration

  def change do
    create table(:campus, primary_key: false) do
      add :acronimo, :string, primary_key: true, null: false
      add :nome, :string
      add :nome_universidade, :string
      add :id_publico, :string

      add :endereco_cep, references(:endereco, column: :cep, type: :string), null: false

      timestamps()
    end

    create unique_index(:campus, [:endereco_cep, :acronimo])
  end
end
