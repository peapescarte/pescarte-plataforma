# priv/repo/migrations/*_create_documents.exs
defmodule Pescarte.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string, null: false
      add :document_link, :string, null: false
      add :unit_id, references(:units, on_delete: :delete_all, type: :binary_id), null: false

      add :document_type_id,
          references(:document_types, on_delete: :delete_all, type: :binary_id),
          null: false

      add :created_by, :binary_id, null: false
      add :updated_by, :binary_id, null: false

      timestamps()
    end

    create index(:documents, [:unit_id])
    create index(:documents, [:document_type_id])

    # create unique_index(:documents, [:unit_id, :document_type_id], name: :documents_unit_id_document_type_id_index)
  end
end
