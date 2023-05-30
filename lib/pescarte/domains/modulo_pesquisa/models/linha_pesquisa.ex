defmodule Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @opaque t :: %LinhaPesquisa{
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
    field :id_publico, :string

    belongs_to :nucleo_pesquisa, NucleoPesquisa
    belongs_to :responsavel_lp, Pesquisador, foreign_key: :responsavel_lp_id

    timestamps()
  end

  @spec changeset(map) :: Result.t(struct, changeset)
  def changeset(linha_pesquisa \\ %__MODULE__{}, attrs) do
    linha_pesquisa
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:nucleo_pesquisa_id)
    |> foreign_key_constraint(:responsavel_lp_id)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end
end
