defmodule Pescarte.CotacoesETL.Handlers.IManagePDFConverterHandler do
  @callback trigger_pdf_conversion_to_txt(Path.t(), Path.t(), pid) :: :ok
  @callback convert_to_txt!(Path.t()) :: binary
end
