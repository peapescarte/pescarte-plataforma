defmodule Fuschia.ModuloPesquisa.Models.Campus do
  @moduledoc """
  Campus Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.{Cidade, Pesquisador}
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(sigla cidade_municipio)a
  @optional_fields ~w(nome)a

  @primary_key {:id, :string, autogenerate: false}
  schema "campus" do
    field :nome, TrimmedString
    field :sigla, TrimmedString

    belongs_to :cidade, Cidade, on_replace: :delete

    has_many :pesquisadores, Pesquisador

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> unique_constraint(:sigla, name: :campus_pkey)
    |> foreign_key_constraint(:cidade_municipio)
    |> put_change(:id, Nanoid.generate())
  end

  @spec foreign_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def foreign_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:cidade_municipio | @required_fields])
    |> validate_required([:cidade_municipio | @required_fields])
    |> unique_constraint([:sigla, :cidade_municipio], name: :campus_sigla_municipio_index)
    |> foreign_key_constraint(:cidade_municipio)
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.Campus

    @spec encode(Campus.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Campus.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
