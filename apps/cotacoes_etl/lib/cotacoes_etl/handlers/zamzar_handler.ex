defmodule CotacoesETL.Handlers.ZamzarHandler do
  import CotacoesETL.Integrations, only: [zamzar_api: 0]

  alias CotacoesETL.Handlers.IManageZamzarHandler
  alias CotacoesETL.Schemas.Zamzar.Job
  alias CotacoesETL.Workers.Pesagro.CotacaoConverter

  require Logger

  @behaviour IManageZamzarHandler

  @impl true
  def download_pesagro_txt!(%Job{} = job, storage_path) do
    txt_file = List.first(job.target_files)
    path = storage_path <> txt_file.name
    file = zamzar_api().download_converted_file!(txt_file.id, path)
    Logger.info("[#{__MODULE__}] ==> Arquivo #{inspect(file.name)} baixado da Zamzar")

    file
  end

  @impl true
  def upload_pesagro_pdf!(pdf_path, time_offset) do
    job = zamzar_api().start_job!(pdf_path, "txt")
    Logger.info("[#{__MODULE__}] ==> Upload do PDF #{pdf_path} completo em Zamzar")
    CotacaoConverter.trigger_txt_download(job, time_offset)

    job
  end
end
