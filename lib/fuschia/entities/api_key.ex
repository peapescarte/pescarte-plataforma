defmodule Fuschia.Entities.ApiKey do
  @moduledoc """
  API Key Schema
  """

  use Fuschia.Schema

  import Ecto.Changeset

  @required_fields ~w(key description active)a

  schema "api_key" do
    field :key, Ecto.UUID
    field :description, :string
    field :active, :boolean

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
