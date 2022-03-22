defmodule Fuschia.ModuloPesquisa.Queries.RelatorioQueries do
  @moduledoc """
  Queries para interagir com `Relatorio`
  """

  import Ecto.Query, only: [from: 2, join: 4, where: 3]

  alias Fuschia.ModuloPesquisa.Models.RelatorioModel

  @behaviour Fuschia.Query

  @impl true
  def query do
    from relatorio in RelatorioModel,
      order_by: [desc: relatorio.inserted_at]
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
