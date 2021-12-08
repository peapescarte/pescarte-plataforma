defmodule Fuschia.Entities.LinhaPesquisa do
  @moduledoc """
  LinhaPesquisa schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Nucleo
  alias Fuschia.Types.{CapitalizedString, TrimmedString}

  @required_fields ~w(descricao_curta numero nucleo_nome)a
  @optional_fields ~w(descricao_longa)a

  @primary_key {:numero, :integer, []}
  schema "linha_pesquisa" do
    field :descricao_curta, TrimmedString
    field :descricao_longa, TrimmedString

    belongs_to :nucleo, Nucleo,
      references: :nome,
      foreign_key: :nucleo_nome,
      type: CapitalizedString

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:numero, :nucleo_nome])
    |> validate_length(:descricao_curta, max: 50)
    |> validate_length(:descricao_longa, max: 280)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    @spec encode(%Fuschia.Entities.LinhaPesquisa{}, map) :: map
    def encode(struct, opts) do
      Fuschia.Encoder.encode(
        %{
          descricao_curta: struct.descricao_curta,
          descricao_longa: struct.descricao_longa,
          numero: struct.numero,
          nucleo: struct.nucleo
        },
        opts
      )
    end
  end
end
