defmodule Fuschia.Entities.Cidade do
  @moduledoc """
  Cidade schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Universidade

  @required_fields ~w(municipio)a

  @primary_key {:municipio, :string, []}
  schema "cidade" do
    has_many :universidades, Universidade

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        municipio: struct.municipio,
        universidades: struct.universidades
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
