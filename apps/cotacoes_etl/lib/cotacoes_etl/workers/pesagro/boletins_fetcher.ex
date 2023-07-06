defmodule CotacoesETL.Workers.Pesagro.BoletinsFetcher do
  @moduledoc """
  Todos os dias esse Worker visita a página da `Pesagro` e
  busca novos boletins do Mercado Agrícola, a fim de atualizar
  nossa base de dados.
  """

  use GenServer

  alias Cotacoes.Handlers.CotacaoHandler
  alias CotacoesETL.Adapters.Pesagro.Boletim
  alias CotacoesETL.Integrations.PesagroAPI
  alias CotacoesETL.Workers.Pesagro.CotacaoIngester

  require Logger

  @one_day 864 * 100 * 100 * 10

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(boletins) do
    GenServer.cast(__MODULE__, :fetch)
    {:ok, boletins}
  end

  @impl true
  def handle_cast(:fetch, boletins) do
    Logger.info("[#{__MODULE__}] ==> Buscando boletins em Pesagro")

    document = PesagroAPI.fetch_document!()
    boletins_links = PesagroAPI.fetch_all_boletim_links(document)

    # Envia mensagem para si próprio para inserir os boletins
    GenServer.cast(__MODULE__, :insert)

    # Agenda a próxima execução do Fetcher
    schedule_next_fetch()
    {:noreply, boletins ++ boletins_links}
  end

  def handle_cast(:insert, boletins) do
    Logger.info("[#{__MODULE__}] ==> Inserindo novos boletins da Pesagro")

    today = Date.utc_today()
    cotacoes = Boletim.boletins_to_cotacoes(boletins, today)
    cotacoes_diff = CotacaoHandler.reject_inserted_cotacoes(cotacoes)
    Logger.info("[#{__MODULE__}] ==> #{length(cotacoes_diff)} novos boletins achados em Pesagro")

    {:ok, inserted} = CotacaoHandler.insert_cotacoes!(cotacoes_diff)
    Logger.info("[#{__MODULE__}] ==> #{length(inserted)} novas cotações inseridas")

    # Agenda a ingestão dos dados das cotações
    # pelo worker `CotacaoIngester`
    Logger.info("[#{__MODULE__}] ==> Agendando a ingestão das cotações Pesagro inseridas")
    schedule_ingestion()
    {:noreply, []}
  end

  @impl true
  def handle_info(:schedule_fetch, state) do
    GenServer.cast(__MODULE__, :fetch)
    {:noreply, state}
  end

  defp schedule_ingestion do
    Process.send(CotacaoIngester, :ingest, [])
  end

  defp schedule_next_fetch do
    Process.send_after(self(), :schedule_fetch, @one_day)
  end
end
