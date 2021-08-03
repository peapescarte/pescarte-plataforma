defmodule Fuschia.Entities.LinhaPesquisa do
  @moduledoc """
  LinhaPesquisa schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Nucleo

  @required_fields ~w(descricao_curta numero_linha nucleo_nome)a
  @optional_fields ~w(descricao_longa)a

  schema "linha_pesquisa" do
    field :descricao_curta, :string
    field :descricao_longa, :string
    field :numero_linha, :integer

    belongs_to :nucleo, Nucleo, references: :nome, foreign_key: :nucleo_nome

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:numero_linha, :nucleo_nome], name: :numero_linha_nucleo_nome_index)
    |> validate_length(:descricao_curta, max: 50)
    |> validate_length(:descricao_longa, max: 280)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        descricao_curta: struct.descricao_curta,
        descricao_longa: struct.descricao_longa,
        numero_linha: struct.numero_linha,
        nucleo_nome: struct.nucleo_nome
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
