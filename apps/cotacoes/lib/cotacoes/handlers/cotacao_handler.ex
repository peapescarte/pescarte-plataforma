defmodule Cotacoes.Handlers.CotacaoHandler do
  alias Cotacoes.Repository

  @behaviour Cotacoes.Handlers.IManageCotacaoHandler

  @impl true
  defdelegate list_cotacao, to: Repository

  @impl true
  defdelegate fetch_cotacao_by_link(link), to: Repository

  @impl true
  def find_cotacoes_not_ingested do
    Repository.find_all_cotacao_by_not_ingested()
  end

  @impl true
  def find_cotacoes_not_downloaded do
    Repository.find_all_cotacao_by_not_downloaded()
  end

  @impl true
  def get_cotacao_file_base_name(cotacao) do
    cotacao.link
    |> String.split("/")
    |> List.last()
  end

  @impl true
  def ingest_cotacoes(cotacoes) do
    {:ok, _} = Repository.update_all_cotacao(cotacoes, importada?: true)
    :ok
  end

  @impl true
  def insert_cotacoes!(cotacoes) do
    Repository.insert_all_cotacao(cotacoes)
  end

  @impl true
  def reject_inserted_cotacoes(cotacoes) do
    current = Enum.map(Repository.list_cotacao(), & &1.link)
    Enum.reject(cotacoes, &(&1.link in current))
  end

  @impl true
  def set_cotacao_downloaded(cotacao) do
    Repository.upsert_cotacao(cotacao, %{baixada?: true})
  end
end
