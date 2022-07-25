defmodule Fuschia.Repo.Migrations.CreateCidade do
  use Ecto.Migration

  def change do
    create table(:cidade, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :municipio, :string, null: false

      timestamps()
    end
  end
end
