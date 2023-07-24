defmodule CotacoesETL.Workers.Pesagro.CotacaoDownloader do
  @moduledoc """
  Este worker é responsável por baixar cada boletim da Pesagro.
  Assim que novos boletins são encontrados pelo worker `BoletinsFetcher`,
  uma mensagem é disparada para este worker para baixá-lo.

  Caso o boletim seja um PDF, o worker `PDFConverter` será acionado,
  e caso seja um ZIP, o worker `ZIPExtractor` será acionado em seu
  lugar.
  """

  use GenServer

  alias Cotacoes.Models.Cotacao
  alias CotacoesETL.Events.ConvertPDFEvent
  alias CotacoesETL.Events.ExtractZIPEvent
  alias CotacoesETL.Events.IngestCotacaoEvent
  alias CotacoesETL.Events.PDFConvertedEvent
  alias CotacoesETL.Handlers.PesagroHandler
  alias CotacoesETL.Logic.PesagroLogic
  alias CotacoesETL.Workers.PDFConverter
  alias CotacoesETL.Workers.Pesagro.CotacaoIngester
  alias CotacoesETL.Workers.ZIPExtractor

  require Logger

  @storage_path "/tmp/peapescarte/cotacoes/pesagro/"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    unless File.exists?(@storage_path) do
      File.mkdir_p!(@storage_path)
    end

    {:ok, nil}
  end

  @impl true
  def handle_cast({:download, cotacao}, _) do
    unless cotacao.baixada? do
      Logger.info("[#{__MODULE__}] ==> Baixando cotação #{cotacao.link} da Pesagro")

      {cotacao, file_path} = PesagroHandler.download_cotacao_from_pesagro!(@storage_path, cotacao)

      cotacao
      |> maybe_send_extract_zip_message(file_path)
      |> maybe_send_convert_pdf_message(file_path)
    end

    {:noreply, nil}
  end

  @impl true
  def handle_info({:download, cotacao}, _) do
    GenServer.cast(__MODULE__, {:download, cotacao})
    {:noreply, nil}
  end

  @impl true
  def handle_info({:pdf_converted, %PDFConvertedEvent{} = event}, state) do
    event = IngestCotacaoEvent.new(%{file_path: event.file_path, cotacao: event.cotacao})
    Process.send(CotacaoIngester, {:ingest, event}, [])

    {:noreply, state}
  end

  @impl true
  def handle_info({:zip_extracted, entries_path}, state) do
    for entry <- entries_path do
      {:ok, cotacao} = PesagroLogic.fetch_cotacao_by_file_path(entry, @storage_path)

      event =
        ConvertPDFEvent.new(%{
          cotacao: cotacao,
          pdf_path: entry,
          destination_path: @storage_path,
          issuer: self(),
          format: :txt
        })

      Process.send(PDFConverter, {:convert, event}, [])
    end

    {:noreply, state}
  end

  defp maybe_send_extract_zip_message(%Cotacao{tipo: :zip} = cotacao, path) do
    storage = Path.join(@storage_path, cotacao.id)

    event =
      ExtractZIPEvent.new(%{
        zip_path: path,
        destination_path: storage,
        issuer: self()
      })

    Process.send(ZIPExtractor, {:extract, event}, [])

    cotacao
  end

  defp maybe_send_extract_zip_message(cotacao, _), do: cotacao

  defp maybe_send_convert_pdf_message(%Cotacao{tipo: :pdf} = cotacao, path) do
    event =
      ConvertPDFEvent.new(%{
        cotacao: cotacao,
        pdf_path: path,
        destination_path: @storage_path,
        issuer: self(),
        format: :txt
      })

    Process.send(PDFConverter, {:convert, event}, [])

    cotacao
  end

  defp maybe_send_convert_pdf_message(cotacao, _), do: cotacao
end
