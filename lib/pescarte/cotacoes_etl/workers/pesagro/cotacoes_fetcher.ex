defmodule Pescarte.CotacoesETL.Workers.Pesagro.Pescarte.CotacoesFetcher do
  @moduledoc """
  Todos os dias esse Worker visita a página da `Pesagro` e
  busca novos boletins do Mercado Agrícola, a fim de atualizar
  nossa base de dados.
  """

  use GenServer

  alias Pescarte.Cotacoes.Handlers.CotacaoHandler
  alias Pescarte.CotacoesETL.Integrations.PesagroAPI
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacaoDownloader

  require Logger

  @one_day 864 * 100 * 100 * 10

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def trigger_fetching do
    GenServer.cast(__MODULE__, :fetch)
  end

  @impl true
  def init(_) do
    # Process.send_after(__MODULE__, :schedule_fetch, @half_minute)
    {:ok, nil}
  end

  @impl true
  def handle_cast(:fetch, _) do
    Logger.info("[#{__MODULE__}] ==> Buscando novas cotações em Pesagro")

    document = PesagroAPI.fetch_document!()
    links = PesagroAPI.fetch_all_links(document)
    today = Date.utc_today()

    cotacoes =
      links
      |> Enum.map(&insert_cotacao(&1, today))
      |> Enum.filter(fn
        {:ok, cot} -> cot
        {:error, _} -> nil
      end)

    if Enum.empty?(cotacoes) do
      Logger.info("[#{__MODULE__}] ==> Nenhuma nova cotação encontrada em Pesagro")
    end

    # Agenda a próxima execução do Fetcher
    schedule_next_fetch()

    {:noreply, nil}
  end

  @impl true
  def handle_info(:schedule_fetch, state) do
    GenServer.cast(__MODULE__, :fetch)
    {:noreply, state}
  end

  defp schedule_next_fetch do
    Process.send_after(self(), :schedule_fetch, @one_day)
  end

  defp insert_cotacao(link, today) do
    with {:ok, cotacao} <- CotacaoHandler.insert_cotacao_pesagro(link, today) do
      base_name = CotacaoHandler.get_cotacao_file_base_name(cotacao)
      Logger.info("[#{__MODULE__}] ==> Cotação Pesagro #{base_name} inserida")
      GenServer.cast(CotacaoDownloader, {:download, cotacao})
      {:ok, cotacao}
    end
  end
end
