defmodule Fuschia.ModuloPesquisa.Models.Midia do
  @moduledoc """
  Midia Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
   tipo
   link
   tags
   pesquisador_id
  )a

  @tipos_midia ~w(video imagem documento)

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "midia" do
    field :tipo, TrimmedString
    field :link, TrimmedString
    field :tags, {:array, TrimmedString}

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> validate_inclusion(:tipo, @tipos_midia)
    |> foreign_key_constraint(:pesquisador_cpf)
    |> put_change(:id, Nanoid.generate())
  end
end
