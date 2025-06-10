defmodule Pescarte.Municipios.DocumentType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "document_types" do
    field :name, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    has_many :documents, Pescarte.Municipios.Document

    timestamps()
  end

  @doc false
  def changeset(document_type, attrs) do
    document_type
    |> cast(attrs, [:name, :created_by, :updated_by])
    |> validate_required([:name, :created_by, :updated_by], message: "* Esse campo é obrigatório")
  end
end
