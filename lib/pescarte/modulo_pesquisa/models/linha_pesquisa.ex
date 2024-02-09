defmodule Pescarte.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

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

  @required_fields ~w(desc_curta numero)a

  @primary_key {:numero, :integer, autogenerate: false}
  schema "linha_pesquisa" do
    field(:desc_curta, :string)
    field(:desc, :string)
    field(:id, Pescarte.Database.Types.PublicId, autogenerate: true)

    belongs_to(:nucleo_pesquisa, NucleoPesquisa,
      foreign_key: :nucleo_pesquisa_letra,
      references: :letra,
      type: :string
    )

    many_to_many(:pesquisadores, Pesquisador,
      join_through: "pesquisador_lp",
      on_replace: :delete
    )

    timestamps()
  end

  @spec changeset(LinhaPesquisa.t(), map) :: changeset
  def changeset(%LinhaPesquisa{} = linha_pesquisa, attrs) do
    linha_pesquisa
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:desc_curta, max: 200)
    # |> validate_length(:desc, max: 280)
    |> foreign_key_constraint(:nucleo_pesquisa_letra)
  end
end
