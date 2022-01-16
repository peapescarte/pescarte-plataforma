defmodule Fuschia.Queries.Campi do
  @moduledoc """
  Queries para interagir com `Campi`
  """

  import Ecto.Query, only: [from: 2, join: 5, where: 3]

  alias Fuschia.Entities.{Campus, Cidade}

  @behaviour Fuschia.Query

  @impl true
  def query do
    from campus in Campus,
      order_by: [desc: campus.created_at]
  end

  @spec query_by_municipio(binary) :: Ecto.Query.t()
  def query_by_municipio(municipio) do
    query()
    |> join(:inner, [campus], c in Cidade, on: campus.cidade_municipio == c.municipio)
    |> where([campus], campus.cidade_municipio == ^municipio)
  end

  @impl true
  def relationships, do: [:pesquisadores, cidade: [:campi]]
end
