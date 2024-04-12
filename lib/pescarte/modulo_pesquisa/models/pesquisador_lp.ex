defmodule Pescarte.ModuloPesquisa.Models.PesquisadorLP do
  use Pescarte, :model

  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %__MODULE__{
          id: integer,
          pesquisador: Pesquisador.t(),
          linha_pesquisa: LinhaPesquisa.t(),
          lider?: boolean
        }

  @required_fields ~w(pesquisador_id linha_pesquisa_id lider?)a

  schema "pesquisador_lp" do
    field :lider?, :boolean, default: false

    belongs_to :pesquisador, Pesquisador, type: :string
    belongs_to :linha_pesquisa, LinhaPesquisa, type: :string
  end

  @spec changeset(PesquisadorLP.t(), map) :: changeset
  def changeset(pesquisador_lp \\ %PesquisadorLP{}, attrs) do
    pesquisador_lp
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador_id)
    |> foreign_key_constraint(:linha_pesquisa_id)
  end
end
