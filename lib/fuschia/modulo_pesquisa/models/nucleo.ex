defmodule Fuschia.ModuloPesquisa.Models.Nucleo do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(nome desc)a

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "core" do
    field :nome, CapitalizedString
    field :desc, :string

    has_many :linhas, LinhaPesquisa

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:desc, max: 400)
    |> put_change(:id, Nanoid.generate())
  end
end
