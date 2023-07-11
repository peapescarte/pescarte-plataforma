defmodule CotacoesETL.Workers.Pesagro.BoletimDownloader do
  @moduledoc """
  Este worker é responsável por baixar cada boletim da Pesagro.
  Assim que novos boletins são encontrados pelo worker `BoletinsFetcher`,
  uma mensagem é disparada para este worker para baixá-lo.

  Caso o boletim seja um PDF, o worker `PDFConverter` será acionado,
  e caso seja um ZIP, o worker `ZIPExtractor` será acionado em seu
  lugar.
  """

  use GenServer

  import CotacoesETL.Handlers,
    only: [pesagro_handler: 0, pdf_converter_handler: 0, zip_extractor_handler: 0]

  alias Cotacoes.Handlers.CotacaoHandler
  # alias CotacoesETL.Workers.Pesagro.BoletimIngester

  require Logger

  @storage_path "/tmp/peapescarte/cotacoes/pesagro/"

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    unless File.exists?(@storage_path) do
      File.mkdir_p!(@storage_path)
    end

    {:ok, state}
  end

  @impl true
  def handle_cast({:download, boletim}, state) do
    Logger.info("[#{__MODULE__}] ==> Baixando boletim #{boletim.link} da Pesagro")

    {:ok, cotacao} = CotacaoHandler.fetch_cotacao_by_link(boletim.link)
    file_path = pesagro_handler().download_boletim_from_pesagro!(@storage_path, cotacao)

    Logger.info("[#{__MODULE__}] ==> Boletim #{boletim.link} da Pesagro baixado")

    if pesagro_handler().is_zip_file?(boletim) do
      zip_extractor_handler().trigger_extract_zip_to_path(file_path, @storage_path, __MODULE__)
    else
      pdf_converter_handler().trigger_pdf_conversion_to_txt(file_path, @storage_path, __MODULE__)
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:download, boletim}, state) do
    GenServer.cast(__MODULE__, {:download, boletim})
    {:noreply, state}
  end

  @impl true
  def handle_info({:pdf_converted, _file_path}, state) do
    # BoletimIngester.ingest_cotacoes_pescados_boletim_file(file_path)
    {:noreply, state}
  end

  @impl true
  def handle_info({:zip_extracted, entries_path}, state) do
    Enum.each(
      entries_path,
      &pdf_converter_handler().trigger_pdf_conversion_to_txt(&1, @storage_path, __MODULE__)
    )

    {:noreply, state}
  end
end
