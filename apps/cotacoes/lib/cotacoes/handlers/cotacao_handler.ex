defmodule Cotacoes.Handlers.CotacaoHandler do
  alias Cotacoes.Repository

  @behaviour Cotacoes.Handlers.IManageCotacaoHandler

  @impl true
  def find_cotacoes_not_ingested do
    Repository.find_all_cotacao_by_is_ingested()
  end

  @impl true
  def ingest_cotacoes(cotacoes) do
    {:ok, _} = Repository.update_all_cotacao(cotacoes)
    :ok
  end

  @impl true
  def insert_cotacoes!(cotacoes) do
    Repository.insert_all_cotacao(cotacoes)
  end

  @impl true
  def reject_inserted_cotacoes(cotacoes) do
    cotacoes_ids =
      cotacoes
      |> Enum.sort_by(& &1.id_publico)
      |> Enum.map(& &1.link)
      |> MapSet.new()

    current = Repository.list_cotacao()

    current_ids =
      current
      |> Enum.sort_by(& &1.id_publico)
      |> Enum.map(& &1.link)
      |> MapSet.new()

    diff_ids = MapSet.difference(current_ids, cotacoes_ids)

    Enum.filter(cotacoes ++ current, &(&1 in diff_ids))
  end
end
