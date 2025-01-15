defmodule Pescarte.Municipios.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @status_values [:concluido, :pendente, :em_andamento]

  schema "documents" do
    field :status, Ecto.Enum, values: @status_values
    field :document_link, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    belongs_to :unit, Pescarte.Municipios.Unit, type: :binary_id
    belongs_to :document_type, Pescarte.Municipios.DocumentType, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [
      :status,
      :document_link,
      :created_by,
      :updated_by,
      :unit_id,
      :document_type_id
    ])
    |> validate_required([
      :status,
      :document_link,
      :created_by,
      :updated_by,
      :unit_id,
      :document_type_id
    ])
    |> validate_format(:document_link, ~r/^https?:\/\/\S+$/, message: "deve ser uma URL válida")
    |> assoc_constraint(:unit)
    |> assoc_constraint(:document_type)

    # |> unique_constraint([:unit_id, :document_type_id], name: :documents_unit_id_document_type_id_index)
  end
end
