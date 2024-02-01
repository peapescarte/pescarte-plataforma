defmodule Pescarte.ModuloPesquisa.Schemas.ConteudoMensal do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

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

  embedded_schema do
    for field <- @fields do
      field(field, :string)
    end
  end

  @doc false
  def changeset(conteudo, attrs) do
    conteudo
    |> cast(attrs, @fields)
    |> validate_required([])
  end
end
