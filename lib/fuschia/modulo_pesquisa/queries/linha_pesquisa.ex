defmodule Fuschia.ModuloPesquisa.Queries.LinhaPesquisa do
  @moduledoc """
  Queries para interagir com `LinhaPesquisa`
  """

  import Ecto.Query, only: [from: 2, join: 5, where: 3]

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa
  alias Fuschia.ModuloPesquisa.Models.Nucleo

  @behaviour Fuschia.Query

  @impl true
  def query do
    from l in LinhaPesquisa,
      order_by: [desc: l.inserted_at]
  end

  @spec query_by_nucleo(binary) :: Ecto.Query.t()
  def query_by_nucleo(nucleo_id) do
    query()
    |> join(:inner, [l], n in Nucleo, on: l.nucleo_id == n.id)
    |> where([l], l.nucleo_id == ^nucleo_id)
  end

  @impl true
  def relationships, do: [:nucleo]
end
