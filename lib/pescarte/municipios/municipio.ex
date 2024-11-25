defmodule Pescarte.Municipios.Municipio do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "muncipios" do
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
    |> validate_required([:name, :created_by, :updated_by])
  end
end
