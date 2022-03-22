defmodule Fuschia.ModuloPesquisa.Queries.LinhaPesquisaQueries do
  @moduledoc """
  Queries para interagir com `LinhaPesquisa`
  """

  import Ecto.Query, only: [from: 2, join: 5, where: 3]

  alias Fuschia.ModuloPesquisa.Models.{LinhaPesquisaModel, NucleoModel}

  @behaviour Fuschia.Query

  @impl true
  def query do
    from l in LinhaPesquisaModel,
      order_by: [desc: l.inserted_at]
  end

  @spec query_by_nucleo(binary) :: Ecto.Query.t()
  def query_by_nucleo(nome_nucleo) do
    query()
    |> join(:inner, [l], n in NucleoModel, on: l.nucleo_nome == n.nome)
    |> where([l], l.nucleo_nome == ^nome_nucleo)
  end

  @impl true
  def relationships, do: [:nucleo]
end
