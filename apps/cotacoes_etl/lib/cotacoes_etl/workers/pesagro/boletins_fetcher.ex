defmodule CotacoesETL.Workers.Pesagro.BoletinsFetcher do
  @moduledoc """
  Todos os dias esse Worker visita a página da `Pesagro` e
  busca novos boletins do Mercado Agrícola, a fim de atualizar
  nossa base de dados.
  """

  use GenServer

  alias Cotacoes.Handlers.CotacaoHandler
  alias CotacoesETL.Adapters.Pesagro.Boletim
  alias CotacoesETL.Integrations
  alias CotacoesETL.Integrations.PesagroAPI
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry
  alias CotacoesETL.Workers.Pesagro.BoletimDownloader

  require Logger

  @one_day 864 * 100 * 100 * 10
  @half_minute 30 * 100 * 10

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_current_boletins do
    GenServer.call(__MODULE__, :get_current)
  end

  def trigger_fetching do
    GenServer.cast(__MODULE__, :fetch)
  end

  @impl true
  def init(boletins) do
    Process.send_after(__MODULE__, :schedule_fetch, @half_minute)
    {:ok, boletins}
  end

  @impl true
  def handle_call(:get_current, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:fetch, boletins) do
    Logger.info("[#{__MODULE__}] ==> Buscando boletins em Pesagro")

    document = Integrations.pesagro_api().fetch_document!()
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
    :ok = CotacaoHandler.insert_cotacoes!(cotacoes_diff)

    for %BoletimEntry{} = boletim <- boletins do
      GenServer.cast(BoletimDownloader, {:download, boletim})
    end

    {:noreply, []}
  end

  @impl true
  def handle_info(:schedule_fetch, state) do
    GenServer.cast(__MODULE__, :fetch)
    {:noreply, state}
  end

  defp schedule_next_fetch do
    Process.send_after(self(), :schedule_fetch, @one_day)
  end
end
