defmodule Fuschia.Repo.Migrations.CreateNucleo do
  use Ecto.Migration

  def change do
    create table(:nucleo, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :nome, :string, null: false
      add :desc, :string, size: 400, null: false

      timestamps()
    end
  end
end
