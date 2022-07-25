defmodule Fuschia.ModuloPesquisa.Models.Core do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(name desc)a

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "core" do
    field :name, CapitalizedString
    field :desc, :string

    has_many :lines, LinhaPesquisa

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
