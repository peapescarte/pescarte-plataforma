defmodule Fuschia.ModuloPesquisa.Queries.CampusQueries do
  @moduledoc """
  Queries para interagir com `Campus`
  """

  import Ecto.Query, only: [from: 2, join: 5, where: 3]

  alias Fuschia.ModuloPesquisa.Models.{CampusModel, CidadeModel}

  @behaviour Fuschia.Query

  @impl true
  def query do
    from campus in CampusModel,
      order_by: [desc: campus.inserted_at]
  end

  @spec query_by_municipio(binary) :: Ecto.Query.t()
  def query_by_municipio(municipio) do
    query()
    |> join(:inner, [campus], c in CidadeModel, on: campus.cidade_municipio == c.municipio)
    |> where([campus], campus.cidade_municipio == ^municipio)
  end

  @impl true
  def relationships, do: [:pesquisadores, cidade: [:campi]]
end
