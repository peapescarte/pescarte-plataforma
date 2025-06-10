defmodule Pescarte.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :municipio_id, references(:municipios, on_delete: :delete_all, type: :binary_id),
        null: false

      add :name, :string, null: false
      add :situation, :string, null: false
      add :next_step, :string
      add :created_by, :binary_id, null: false
      add :updated_by, :binary_id, null: false

      timestamps()
    end

    create index(:units, [:municipio_id])
  end
end
