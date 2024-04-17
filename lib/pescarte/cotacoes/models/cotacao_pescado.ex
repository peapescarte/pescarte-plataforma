defmodule Pescarte.Cotacoes.Models.CotacaoPescado do
  use Pescarte, :model

  alias Pescarte.Cotacoes.Models.Cotacao
  alias Pescarte.Cotacoes.Models.Fonte
  alias Pescarte.Cotacoes.Models.Pescado
  alias Pescarte.Database.Types.PublicId

  @type t :: %CotacaoPescado{
          id: binary,
          cotacao: Cotacao.t(),
          pescado: Pescado.t(),
          fonte: Fonte.t(),
          preco_minimo: integer,
          preco_maximo: integer,
          preco_mais_comum: integer,
          preco_medio: integer
        }

  @required_fields ~w(cotacao_id pescado_id fonte_id preco_minimo preco_maximo)a
  @optional_fields ~w(preco_mais_comum preco_medio)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "cotacoes_pescados" do
    field :preco_minimo, :integer
    field :preco_maximo, :integer
    field :preco_mais_comum, :integer
    field :preco_medio, :integer

    belongs_to :fonte, Fonte, type: :string
    belongs_to :cotacao, Cotacao, type: :string
    belongs_to :pescado, Pescado, type: :string
  end

  @spec changeset(CotacaoPescado.t(), map) :: changeset
  def changeset(%CotacaoPescado{} = cot_pescado, attrs) do
    cot_pescado
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:cotacao_id)
    |> foreign_key_constraint(:pescado_id)
    |> foreign_key_constraint(:fonte_id)
  end
end
