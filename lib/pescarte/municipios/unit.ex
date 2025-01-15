defmodule Pescarte.Municipios.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "units" do
    field :name, :string
    field :situation, :string
    field :next_step, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    belongs_to :municipio, Pescarte.Municipios.Municipio, type: :binary_id

    # Relação 1:N com Document
    has_many :documents, Pescarte.Municipios.Document

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [
      :municipio_id,
      :name,
      :situation,
      :next_step,
      :created_by,
      :updated_by
    ])
    |> validate_required([:municipio_id, :name, :created_by, :updated_by])
    |> assoc_constraint(:municipio)
  end
end
