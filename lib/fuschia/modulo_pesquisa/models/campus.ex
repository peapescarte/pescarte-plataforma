defmodule Fuschia.ModuloPesquisa.Models.CampusModel do
  @moduledoc """
  Campus Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.{CidadeModel, PesquisadorModel}
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(nome)a

  @primary_key {:nome, CapitalizedString, autogenerate: false}
  schema "campus" do
    field :id, :string

    belongs_to :cidade, CidadeModel,
      type: :string,
      on_replace: :delete,
      references: :municipio,
      foreign_key: :cidade_municipio

    has_many :pesquisadores, PesquisadorModel, foreign_key: :campus_nome

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> cast_assoc(:cidade, required: true)
    |> put_change(:id, Nanoid.generate())
  end

  @spec foreign_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def foreign_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:cidade_municipio | @required_fields])
    |> validate_required([:cidade_municipio | @required_fields])
    |> unique_constraint([:nome, :cidade_municipio], name: :campus_nome_municipio_index)
    |> foreign_key_constraint(:cidade_municipio)
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.CampusAdapter

    @spec encode(Campus.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> CampusAdapter.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
