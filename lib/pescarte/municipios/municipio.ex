defmodule Pescarte.Municipios.Municipio do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "municipios" do
    field :name, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    has_many :units, Pescarte.Municipios.Unit

    timestamps()
  end

  @doc false
  def changeset(municipio, attrs) do
    municipio
    |> cast(attrs, [:name, :created_by, :updated_by])
    |> cast_assoc(:units, with: &Pescarte.Municipios.Unit.changeset/2, required: false)
    |> validate_required([:name, :created_by, :updated_by], message: "* Esse campo é obrigatório")
  end
end
