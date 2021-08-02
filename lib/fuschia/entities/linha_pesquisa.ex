defmodule Fuschia.Entities.LinhaPesquisa do
  @moduledoc """
  LinhaPesquisa schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Nucleo

  @required_fields ~w(descricao_curta numero_linha nome_nucleo)a
  @optional_fields ~w(descricao_longa)a

  schema "linha_pesquisa" do
    field :descricao_curta, :string
    field :descricao_longa, :string
    field :numero_linha, :integer
    belongs_to :nucleo, Nucleo, references: :nome, foreign_key: :nome_nucleo

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:numero_linha, :nome_nucleo], name: :numero_linha_nome_nucleo_index)
    |> validate_length(:descricao_longa, max: 280)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        descricao_curta: struct.descricao_curta,
        descricao_longa: struct.descricao_longa,
        numero_linha: struct.numero_linha,
        nome_nucleo: struct.nome_nucleo
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
