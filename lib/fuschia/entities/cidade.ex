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
    field :id_externo, :string

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> unique_constraint(:municipio)
    |> validate_required(@required_fields)
    |> put_change(:id_externo, Nanoid.generate())
  end

  @spec to_map(%__MODULE__{}) :: map
  def to_map(%__MODULE__{} = struct) do
    %{
      id: struct.id_externo,
      municipio: struct.municipio,
      campi: struct.campi
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.Entities.Cidade

    @spec encode(Cidade.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Cidade.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
