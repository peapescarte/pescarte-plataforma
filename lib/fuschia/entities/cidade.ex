defmodule Fuschia.Entities.Cidade do
  @moduledoc """
  Cidade schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  @primary_key {:municipio, :string, []}
  schema "cidade" do
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:municipio])
    |> validate_required([:municipio])
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        municipio: struct.municipio
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
