defmodule Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @type t :: %RelatorioMensal{
          acao_planejamento: binary,
          participacao_grupos_estudo: binary,
          acoes_pesquisa: binary,
          participacao_treinamentos: binary,
          publicacao: binary,
          previsao_acao_planejamento: binary,
          previsao_participacao_grupos_estudo: binary,
          previsao_participacao_treinamentos: binary,
          previsao_acoes_pesquisa: binary,
          status: atom,
          link: binary,
          ano: integer,
          mes: integer,
          pesquisador: Pesquisador.t(),
          id_publico: binary
        }

  @status ~w(entregue atrasado pendente)a

  @required_fields ~w(ano mes pesquisador_id)a

  @optional_fields ~w(
    acao_planejamento
    participacao_grupos_estudo
    acoes_pesquisa
    participacao_treinamentos
    publicacao
    previsao_acao_planejamento
    previsao_participacao_grupos_estudo
    previsao_participacao_treinamentos
    previsao_acoes_pesquisa
    status
    link
  )a

  @primary_key false
  schema "relatorio_mensal_pesquisa" do
    # Primeira seção
    field :acao_planejamento, :string
    field :participacao_grupos_estudo, :string
    field :acoes_pesquisa, :string
    field :participacao_treinamentos, :string
    field :publicacao, :string

    # Segunda seção
    field :previsao_acao_planejamento, :string
    field :previsao_participacao_grupos_estudo, :string
    field :previsao_participacao_treinamentos, :string
    field :previsao_acoes_pesquisa, :string

    field :status, Ecto.Enum, values: @status, default: :pendente
    field :ano, :integer, primary_key: true
    field :mes, :integer, primary_key: true
    field :link, :string
    field :id_publico, Pescarte.Types.PublicId, autogenerate: true

    belongs_to :pesquisador, Pesquisador,
      on_replace: :update,
      references: :id_publico,
      type: :string

    timestamps()
  end

  @spec changeset(RelatorioMensal.t(), map) :: changeset
  def changeset(%RelatorioMensal{} = relatorio_mensal, attrs) do
    relatorio_mensal
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador_id)
  end
end
