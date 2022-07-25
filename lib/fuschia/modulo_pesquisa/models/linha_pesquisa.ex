defmodule Fuschia.ModuloPesquisa.Models.LinhaPesquisa do
  @moduledoc """
  LinhaPesquisa schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.Nucleo
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(core_id descricao_curta numero)a
  @optional_fields ~w(descricao_longa)a

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "linha_pesquisa" do
    field :numero, :integer
    field :descricao_curta, TrimmedString
    field :descricao_longa, TrimmedString

    belongs_to :nucleo, Nucleo

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:descricao_curta, max: 50)
    |> validate_length(:descricao_longa, max: 280)
    |> foreign_key_constraint(:nucleo_id)
    |> put_change(:id, Nanoid.generate())
  end
end
