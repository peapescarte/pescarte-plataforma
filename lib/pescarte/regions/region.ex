defmodule Pescarte.Regions.Region do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "regions" do
    field :name, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    has_many :units, Pescarte.Regions.Unit

    timestamps()
  end

  @doc false
  def changeset(region, attrs) do
    region
    |> cast(attrs, [:name, :created_by, :updated_by])
    |> validate_required([:name, :created_by, :updated_by])
  end
end
