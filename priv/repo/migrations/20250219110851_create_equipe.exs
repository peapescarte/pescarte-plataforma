defmodule Pescarte.Database.Repo.Migrations.CreateEquipe do
  use Ecto.Migration

  def change do
    create table(:equipe, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome, :string
      add :descricao, :string
      add :status, :string

      timestamps()
    end
  end
end
