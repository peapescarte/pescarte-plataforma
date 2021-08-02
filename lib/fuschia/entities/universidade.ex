defmodule Fuschia.Entities.Universidade do
  @moduledoc """
  Esquema que representa uma Universidade no BD
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Cidade

  @required_fields ~w(nome nome_cidade)a
  @optional_fields ~w()a

  schema "universidade" do
    field :nome, :string

    belongs_to :cidade, Cidade,
      references: :municipio,
      foreign_key: :nome_cidade

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
        nome_cidade: struct.nome_cidade
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
