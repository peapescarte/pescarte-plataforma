defmodule Pescarte.ModuloPesquisa.Schemas.ConteudoTrimestral do
  use Pescarte, :schema

  @type t :: %ConteudoTrimestral{
    titulo: String.t(),
    introducao: String.t(),
    embasamento_teorico: String.t(),
    resultados_preliminares: String.t(),
    atividades_academicas: String.t(),
    atividades_nao_academicas: String.t(),
    referencias: String.t()
  }

  @fields [
    :titulo,
    :introducao,
    :embasamento_teorico,
    :resultados_preliminares,
    :atividades_academicas,
    :atividades_nao_academicas,
    :referencias
  ]

  @primary_key false
  embedded_schema do
    for field <- @fields do
      field field, :string
    end
  end

  @doc false
  @spec changeset(ConteudoTrimestral.t, map) :: changeset
  def changeset(conteudo, attrs) do
    conteudo
    |> cast(attrs, @fields)
    |> validate_required([])
  end
end
