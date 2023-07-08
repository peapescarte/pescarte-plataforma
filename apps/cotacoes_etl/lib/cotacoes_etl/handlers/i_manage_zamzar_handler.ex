defmodule CotacoesETL.Handlers.IManageZamzarHandler do
  alias CotacoesETL.Schemas.Zamzar.File, as: FileEntry
  alias CotacoesETL.Schemas.Zamzar.Job

  @callback download_pesagro_txt!(Job.t(), Path.t()) :: FileEntry.t()
  @callback upload_pesagro_pdf!(Path.t(), integer) :: Job.t()
end
