defmodule Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @type t :: %LinhaPesquisa{
          id: integer,
          numero: integer,
          desc: binary,
          desc_curta: binary,
          id_publico: binary,
          nucleo_pesquisa: NucleoPesquisa.t(),
          responsavel_lp: Pesquisador.t()
        }

  @required_fields ~w(nucleo_pesquisa_id desc_curta numero)a
  @optional_fields ~w(desc responsavel_lp_id)a

  schema "linha_pesquisa" do
    field :numero, :integer
    field :desc_curta, :string
    field :desc, :string
    field :id_publico, Pescarte.Types.PublicId, autogenerate: true

    belongs_to :nucleo_pesquisa, NucleoPesquisa
    belongs_to :responsavel_lp, Pesquisador, foreign_key: :responsavel_lp_id

    many_to_many :pesquisadores, Pesquisador,
      join_through: "LPs_pesquisadores",
      on_replace: :delete,
      unique: true

    timestamps()
  end

  @spec changeset(LinhaPesquisa.t(), map) :: changeset
  def changeset(%LinhaPesquisa{} = linha_pesquisa, attrs) do
    linha_pesquisa
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:desc_curta, max: 90)
    |> validate_length(:desc, max: 280)
    |> foreign_key_constraint(:nucleo_pesquisa_id)
    |> foreign_key_constraint(:responsavel_lp_id)
  end
end
