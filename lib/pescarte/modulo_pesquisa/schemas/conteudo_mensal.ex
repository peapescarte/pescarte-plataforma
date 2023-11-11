defmodule Pescarte.ModuloPesquisa.Schemas.ConteudoMensal do
  use Pescarte, :schema

  @type t :: %ConteudoMensal{
    acao_planejamento: String.t(),
    participacao_grupos_estudo: String.t(),
    acoes_pesquisa: String.t(),
    participacao_treinamentos: String.t(),
    publicacao: String.t(),
    previsao_acao_planejamento: String.t(),
    previsao_participacao_grupos_estudo: String.t(),
    previsao_participacao_treinamentos: String.t(),
    previsao_acoes_pesquisa: String.t()
  }

  @fields [
    :acao_planejamento,
    :participacao_grupos_estudo,
    :acoes_pesquisa,
    :participacao_treinamentos,
    :publicacao,
    :previsao_acao_planejamento,
    :previsao_participacao_grupos_estudo,
    :previsao_participacao_treinamentos,
    :previsao_acoes_pesquisa
  ]

  @primary_key false
  embedded_schema do
    for field <- @fields do
      field field, :string
    end
  end

  @doc false
  @spec changeset(ConteudoMensal.t(), map()) :: changeset
  def changeset(conteudo, attrs) do
    conteudo
    |> cast(attrs, @fields)
    |> validate_required([])
  end
end
