defmodule Pescarte.Database.Repo.Migrations.CreatePescado do
  use Ecto.Migration

  def change do
    create table(:pescado, primary_key: false) do
      add :id, :string, primary_key: true
      add :codigo, :string, null: false
      add :embalagem, :string, null: false
      add :descricao, :string

      timestamps()
    end
  end
end
