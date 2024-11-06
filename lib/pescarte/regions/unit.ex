defmodule Pescarte.Regions.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "units" do
    field :name, :string
    field :status, :string
    field :next_step, :string
    field :document_link, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    belongs_to :region, Pescarte.Regions.Region, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:region_id, :name, :status, :next_step, :document_link, :created_by, :updated_by])
    |> validate_required([:region_id, :name, :created_by, :updated_by])
    |> validate_format(:document_link, ~r/^https?:\/\/\S+$/, message: "deve ser uma URL válida")
    |> assoc_constraint(:region)
  end
end
