defmodule Fuschia.ModuloPesquisa.Models.LinhaPesquisaModel do
  @moduledoc """
  LinhaPesquisa schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.NucleoModel
  alias Fuschia.Types.{CapitalizedString, TrimmedString}

  @required_fields ~w(descricao_curta numero nucleo_nome)a
  @optional_fields ~w(descricao_longa)a

  @primary_key {:numero, :integer, []}
  schema "linha_pesquisa" do
    field :id, :string
    field :descricao_curta, TrimmedString
    field :descricao_longa, TrimmedString

    belongs_to :nucleo, NucleoModel,
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
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.LinhaPesquisaAdapter

    @spec encode(LinhaPesquisa.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> LinhaPesquisaAdapter.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
