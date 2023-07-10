defmodule CotacoesETL.Handlers.IManageZIPExtractorHandler do
  @callback trigger_extract_zip_to_path(Path.t(), Path.t(), pid) :: :ok
  @callback extract_zip_to!(Path.t(), Path.t()) :: list(Path.t())
end
