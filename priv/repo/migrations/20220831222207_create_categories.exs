defmodule Fuschia.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:category) do
      add :name, :string, null: false

      timestamps()
    end

    create index(:category, [:name])
  end
end
