defmodule CotacoesETL.Handlers.IManagePDFConverterHandler do
  @callback trigger_pdf_convertion_to_txt(Path.t(), Path.t(), pid) :: :ok
  @callback convert_to_txt!(Path.t()) :: binary
end
