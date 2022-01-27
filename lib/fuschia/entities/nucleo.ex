defmodule Fuschia.Entities.Nucleo do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.LinhaPesquisa
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(nome descricao)a

  @primary_key {:nome, CapitalizedString, []}
  schema "nucleo" do
    field :id_externo, :string
    field :descricao, :string

    has_many :linhas_pesquisa, LinhaPesquisa

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:descricao, max: 400)
    |> put_change(:id_externo, Nanoid.generate())
  end

  @spec to_map(%__MODULE__{}) :: map
  def to_map(%__MODULE__{} = struct) do
    %{
      id: struct.id_externo,
      nome: struct.nome,
      descricao: struct.descricao,
      linhas_pesquisa: struct.linhas_pesquisa
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.Entities.Nucleo

    @spec encode(Nucleo.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Nucleo.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
