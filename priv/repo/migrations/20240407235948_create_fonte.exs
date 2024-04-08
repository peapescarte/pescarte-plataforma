defmodule Pescarte.Database.Repo.Migrations.CreateFonte do
  use Ecto.Migration

  def change do
    create table(:fonte_cotacao, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome, :string, null: false
      add :link, :string, null: false
      add :descricao, :string

      timestamps()
    end
  end
end
