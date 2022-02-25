defmodule Fuschia.ModuloPesquisa.Queries.LinhaPesquisa do
  @moduledoc """
  Queries para interagir com `LinhaPesquisa`
  """

  import Ecto.Query, only: [from: 2, join: 5, where: 3]

  alias Fuschia.ModuloPesquisa.Models.{LinhaPesquisa, Nucleo}

  @behaviour Fuschia.Query

  @impl true
  def query do
    from l in LinhaPesquisa,
      order_by: [desc: l.inserted_at]
  end

  @spec query_by_nucleo(binary) :: Ecto.Query.t()
  def query_by_nucleo(nome_nucleo) do
    query()
    |> join(:inner, [l], n in Nucleo, on: l.nucleo_nome == n.nome)
    |> where([l], l.nucleo_nome == ^nome_nucleo)
  end

  @impl true
  def relationships, do: [:nucleo]
end
