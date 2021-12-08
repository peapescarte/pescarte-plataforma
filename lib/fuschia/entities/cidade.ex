defmodule Fuschia.Entities.Cidade do
  @moduledoc """
  Cidade schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Campus
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(municipio)a

  @primary_key {:municipio, CapitalizedString, autogenerate: false}
  schema "cidade" do
    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> unique_constraint(:municipio)
    |> validate_required(@required_fields)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    @spec encode(%Fuschia.Entities.Cidade{}, map) :: map
    def encode(struct, opts) do
      Fuschia.Encoder.encode(
        %{
          municipio: struct.municipio,
          campi: struct.campi
        },
        opts
      )
    end
  end
end
