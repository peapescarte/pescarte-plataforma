defmodule Fuschia.ModuloPesquisa.Models.Cidade do
  @moduledoc """
  Cidade schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.Campus
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(municipio)a

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "cidade" do
    field :municipio, CapitalizedString

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> unique_constraint(:municipio)
    |> validate_required(@required_fields)
    |> put_change(:id, Nanoid.generate())
  end
end
