defmodule Fuschia.Queries.Relatorios do
  @moduledoc """
  Queries para interagir com `Relatorios`
  """

  import Ecto.Query, only: [from: 2, join: 4, where: 3]

  alias Fuschia.Entities.Relatorio

  @behaviour Fuschia.Query

  @impl true
  def query do
    from relatorio in Relatorio,
      order_by: [desc: relatorio.created_at]
  end

  @spec query_by_pesquisador(binary) :: Ecto.Query.t()
  def query_by_pesquisador(pesquisador_cpf) do
    query()
    |> join(:inner, [relatorio], p in assoc(relatorio, :pesquisador))
    |> where([relatorio], relatorio.pesquisador_cpf == ^pesquisador_cpf)
  end

  @impl true
  def relationships, do: [:pesquisador]
end
