defmodule Pescarte.ModuloPesquisa.Schemas.ConteudoTrimestral do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  @fields [
    :titulo,
    :introducao,
    :embasamento_teorico,
    :resultados_preliminares,
    :atividades_academicas,
    :atividades_nao_academicas,
    :referencias
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
