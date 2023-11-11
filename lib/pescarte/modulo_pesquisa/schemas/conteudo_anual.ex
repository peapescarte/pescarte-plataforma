defmodule Pescarte.ModuloPesquisa.Schemas.ConteudoAnual do
  use Pescarte, :schema

  @type t :: %ConteudoAnual{
    plano_de_trabalho: String.t,
    resumo: String.t,
    introducao: String.t,
    embasamento_teorico: String.t,
    resultados: String.t,
    atividades_academicas: String.t,
    atividades_nao_academicas: String.t,
    conclusao: String.t,
    referencias: String.t
  }

  @fields [
    :plano_de_trabalho,
    :resumo,
    :introducao,
    :embasamento_teorico,
    :resultados,
    :atividades_academicas,
    :atividades_nao_academicas,
    :conclusao,
    :referencias
  ]

  @primary_key false
  embedded_schema do
    for field <- @fields do
      field field, :string
    end
  end

  @doc false
  @spec changeset(ConteudoAnual.t, map) :: changeset
  def changeset(conteudo, attrs) do
    conteudo
    |> cast(attrs, @fields)
    |> validate_required([])
  end
end
