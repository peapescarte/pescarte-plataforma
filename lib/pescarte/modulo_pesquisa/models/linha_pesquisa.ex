defmodule Pescarte.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %LinhaPesquisa{
          numero: integer,
          desc: binary,
          desc_curta: binary,
          id: binary,
          nucleo_pesquisa: NucleoPesquisa.t(),
          pesquisadores: list(Pesquisador.t())
        }

  @optinal_fields ~w(desc nucleo_pesquisa_id)a
  @required_fields ~w(desc_curta numero)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "linha_pesquisa" do
    field :numero, :integer
    field :desc_curta, :string
    field :desc, :string

    belongs_to :nucleo_pesquisa, NucleoPesquisa, type: :string

    many_to_many :pesquisadores, Pesquisador,
      join_through: "pesquisador_lp",
      on_replace: :delete,
      unique: true

    timestamps()
  end

  @spec changeset(LinhaPesquisa.t(), map) :: changeset
  def changeset(linha_pesquisa \\ %LinhaPesquisa{}, attrs) do
    linha_pesquisa
    |> cast(attrs, @optinal_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:desc_curta, max: 200)
    |> foreign_key_constraint(:nucleo_pesquisa_id)
  end
end
