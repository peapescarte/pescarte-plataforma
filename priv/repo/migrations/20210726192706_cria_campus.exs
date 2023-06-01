defmodule Pescarte.Repo.Migrations.CriaCampus do
  use Ecto.Migration

  def change do
    create table(:campus) do
      add :acronimo, :string, null: false
      add :nome, :string
      add :nome_universidade, :string
      add :id_publico, :string

      add :endereco_id, references(:endereco), null: false

      timestamps()
    end

    create unique_index(:campus, [:acronimo])
    create unique_index(:campus, [:endereco_id, :acronimo])
  end
end
