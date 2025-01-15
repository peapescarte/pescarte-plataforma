defmodule Pescarte.Municipios.DocumentType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "document_types" do
    field :name, :string

    has_many :documents, Pescarte.Municipios.Document

    timestamps()
  end

  @doc false
  def changeset(document_type, attrs) do
    document_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
