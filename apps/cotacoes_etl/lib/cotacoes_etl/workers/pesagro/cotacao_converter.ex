defmodule CotacoesETL.Workers.Pesagro.CotacaoConverter do
  @moduledoc """
  Este worker e responsável por listar todas as `cotacoes`
  presentes no banco de dados, que ainda não foram baixadas.
  Com isso, esse worker vai realizar todos os uploads e
  conversões de cada arquivo PDF para TXT. E caso a cotação
  seja um ZIP, irá extraí-lo e realizar o passo anterior!

  Ao final desse fluxo, esse worker vai agendar a ingestão
  dessas cotações por um outro (e último) worker `CotacaoIngester`.
  """

  use GenServer

  import CotacoesETL.Handlers
  import CotacoesETL.Integrations

  alias Cotacoes.Handlers.CotacaoHandler
  alias CotacoesETL.Logic.ZamzarLogic
  alias CotacoesETL.Schemas.Zamzar.Job

  require Logger

  @storage_path "/tmp/peapescarte/cotacoes/pesagro/"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def trigger_cotacoes_convertion do
    GenServer.cast(__MODULE__, :convert)
  end

  def trigger_pdf_upload do
    GenServer.cast(__MODULE__, :upload_pdf)
  end

  def trigger_zip_extraction do
    GenServer.cast(__MODULE__, :extract_zip)
  end

  @spec trigger_txt_download(Job.t(), integer) :: :ok
  def trigger_txt_download(job, time_offset) do
    :timer.apply_after(second_to_ms(time_offset), GenServer, :cast, [
      __MODULE__,
      {:download_txt, job}
    ])

    :ok
  end

  @impl true
  def init(_) do
    unless File.exists?(@storage_path) do
      File.mkdir_p!(@storage_path)
    end

    {:ok, nil}
  end

  @impl true
  def handle_cast(:convert, _state) do
    Logger.info(
      "[#{__MODULE__}] ==> Iniciando a conversão pdf->txt de cotações pendentes da Pesagro"
    )

    cotacoes_to_upload = CotacaoHandler.find_cotacoes_not_downloaded()

    Logger.info(
      "#{__MODULE__} ==> #{length(cotacoes_to_upload)} cotações para serem convertidas da Pesagro"
    )

    tasks =
      for cotacao <- cotacoes_to_upload do
        Process.sleep(second_to_ms(1))

        Task.async(fn ->
          file_path = pesagro_handler().download_boletim_from_pesagro!(@storage_path, cotacao)
          Logger.info("[#{__MODULE__}] ==> Arquivo #{file_path} baixado com sucesso da Pesagro")
          file_path
        end)
      end

    files_path = Task.await_many(tasks)

    Logger.info("[#{__MODULE__}] ==> #{length(files_path)} arquivos foram baixados da Pesagro")

    if Enum.any?(files_path, &String.ends_with?(&1, "zip")) do
      trigger_zip_extraction()
    else
      trigger_pdf_upload()
    end

    {:noreply, files_path}
  end

  def handle_cast(:extract_zip, files_path) do
    pdfs =
      files_path
      |> Enum.filter(&String.ends_with?(&1, "zip"))
      |> Enum.map(fn zip_path ->
        Task.async(fn ->
          pesagro_handler().extract_boletins_zip!(zip_path, @storage_path)
        end)
      end)
      |> Task.await_many()
      |> List.flatten()

    Logger.info("[#{__MODULE__}] ==> #{length(pdfs)} PDFs extraídos de arquivos ZIP da Pesagro")

    trigger_pdf_upload()

    {:noreply,
     files_path
     |> Enum.reject(&String.ends_with?(&1, "zip"))
     |> Kernel.++(pdfs)}
  end

  def handle_cast(:upload_pdf, pdfs_paths) do
    for {pdf, idx} <- Enum.with_index(pdfs_paths) do
      Logger.info(
        "[#{__MODULE__}] ==> Fazendo upload do PDF/Cotação #{pdf} para conversão para txt na Zamzar"
      )

      :timer.apply_after(second_to_ms(idx), zamzar_handler(), :upload_pesagro_pdf!, [pdf, idx + 2])
    end

    {:noreply, []}
  end

  def handle_cast({:download_txt, %Job{} = job}, _state) do
    job = zamzar_api().retrieve_job!(job.id)

    if ZamzarLogic.job_is_successful?(job) do
      zamzar_handler().download_pesagro_txt!(job, @storage_path)

      {:noreply, []}
    else
      trigger_txt_download(job, 2)

      {:noreply, []}
    end
  end

  @impl true
  def handle_info(:schedule_convertion, state) do
    GenServer.cast(__MODULE__, :convert)
    {:noreply, state}
  end

  defp second_to_ms(s) do
    s * 100 * 10
  end
end
