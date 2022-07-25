defmodule Fuschia.ModuloPesquisa.Queries.LinhaPesquisa do
  @moduledoc """
  Queries para interagir com `LinhaPesquisa`
  """

  import Ecto.Query, only: [from: 2, join: 5, where: 3]

  alias Fuschia.ModuloPesquisa.Models.Core
  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa

  @behaviour Fuschia.Query

  @impl true
  def query do
    from l in LinhaPesquisa,
      order_by: [desc: l.inserted_at]
  end

  @spec query_by_core(binary) :: Ecto.Query.t()
  def query_by_core(core_id) do
    query()
    |> join(:inner, [l], c in Core, on: l.core_id == c.id)
    |> where([l], l.core_id == ^core_id)
  end

  @impl true
  def relationships, do: [:core]
end
