defmodule Pescarte.Repo.Migrations.CreateDocumentTypes do
  use Ecto.Migration

  def change do
    create table(:document_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :created_by, :binary_id, null: false
      add :updated_by, :binary_id, null: false

      timestamps()
    end
  end
end
