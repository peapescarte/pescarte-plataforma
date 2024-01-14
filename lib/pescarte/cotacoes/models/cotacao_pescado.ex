defmodule Pescarte.Cotacoes.Models.CotacaoPescado do
  use Pescarte, :model

  @type t :: %CotacaoPescado{
          id: binary,
          cotacao_data: Date.t(),
          cotacao_link: String.t(),
          pescado_codigo: binary,
          fonte_nome: binary,
          preco_minimo: integer,
          preco_maximo: integer,
          preco_mais_comum: integer,
          preco_medio: integer
        }

  @required_fields ~w(cotacao_data cotacao_link pescado_codigo fonte_nome preco_minimo preco_maximo)a
  @optional_fields ~w(preco_mais_comum preco_medio)a

  @primary_key false
  schema "cotacoes_pescados" do
    field(:id, Pescarte.Database.Types.PublicId, autogenerate: true)
    field(:cotacao_data, :date, primary_key: true)
    field(:cotacao_link, :string)
    field(:pescado_codigo, :string, primary_key: true)
    field(:fonte_nome, :string, primary_key: true)
    field(:preco_minimo, :integer)
    field(:preco_maximo, :integer)
    field(:preco_mais_comum, :integer)
    field(:preco_medio, :integer)
  end

  @spec changeset(CotacaoPescado.t(), map) :: changeset
  def changeset(%CotacaoPescado{} = cot_pescado, attrs) do
    cot_pescado
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:cotacao_data)
    |> foreign_key_constraint(:cotacao_link)
    |> foreign_key_constraint(:pescado_codigo)
    |> foreign_key_constraint(:fonte_nome)
  end
end
