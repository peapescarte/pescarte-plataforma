defmodule Fuschia.ModuloPesquisa.Models.Campus do
  @moduledoc """
  Campus Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.{Cidade, Pesquisador}
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(sigla cidade_id)a
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
    |> unique_constraint(:sigla)
    |> foreign_key_constraint(:cidade_id)
    |> put_change(:id, Nanoid.generate())
  end

  @spec foreign_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def foreign_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:cidade_id, :nome, :sigla])
    |> unique_constraint(:sigla)
    |> unique_constraint(:nome)
    |> foreign_key_constraint(:cidade_id)
    |> put_change(:id, Nanoid.generate())
  end
end
