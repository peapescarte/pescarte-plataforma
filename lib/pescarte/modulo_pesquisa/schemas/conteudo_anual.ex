defmodule Pescarte.ModuloPesquisa.Schemas.ConteudoAnual do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

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

  embedded_schema do
    for field <- @fields do
      field field, :string
    end
  end

  @doc false
  def changeset(conteudo, attrs) do
    conteudo
    |> cast(attrs, @fields)
    |> validate_required([])
  end
end
