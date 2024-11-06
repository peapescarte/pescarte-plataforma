defmodule Pescarte.Database.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :region_id, references(:regions, type: :binary_id, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :status, :string
      add :next_step, :string
      add :document_link, :string
      add :created_by, :binary_id, null: false
      add :updated_by, :binary_id, null: false

      timestamps()
    end

    create index(:units, [:region_id])
  end
end
