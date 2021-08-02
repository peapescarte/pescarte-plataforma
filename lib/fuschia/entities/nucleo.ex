defmodule Fuschia.Entities.Nucleo do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  @required_fields ~w(nome descricao)a
  @optional_fields ~w()a

  @primary_key {:nome, :string, []}
  schema "nucleo" do
    field :descricao, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:descricao_nucleo, max: 400)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        nome: struct.nome,
        descricao_nucleo: struct.descricao_nucleo
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
