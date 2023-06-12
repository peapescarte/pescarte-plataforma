defmodule Pescarte.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categoria) do
      add :nome, :string, null: false
      add :id_publico, :string

      timestamps()
    end

    create unique_index(:categoria, [:nome])
  end
end
