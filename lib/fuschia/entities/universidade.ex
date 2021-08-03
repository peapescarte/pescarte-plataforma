defmodule Fuschia.Entities.Universidade do
  @moduledoc """
  Universidade Schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Cidade

  @required_fields ~w(nome cidade_municipio)a
  @optional_fields ~w()a

  schema "universidade" do
    field :nome, :string

    belongs_to :cidade, Cidade,
      references: :municipio,
      foreign_key: :cidade_municipio

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        nome: struct.nome,
        cidade_municipio: struct.cidade_municipio
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
