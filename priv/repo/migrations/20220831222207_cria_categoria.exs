defmodule Pescarte.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categoria, primary_key: false) do
      add :nome, :string, null: false, primary_key: true
      add :id_publico, :string

      timestamps()
    end
  end
end
