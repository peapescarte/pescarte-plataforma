defmodule Fuschia.Repo.Migrations.CreateCore do
  use Ecto.Migration

  def change do
    create table(:core, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :desc, :string, size: 400, null: false

      timestamps()
    end
  end
end
