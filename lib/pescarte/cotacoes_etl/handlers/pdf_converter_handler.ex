defmodule Pescarte.CotacoesETL.Handlers.PDFConverterHandler do
  alias Pescarte.CotacoesETL.Handlers.IManagePDFConverterHandler
  alias Pescarte.CotacoesETL.Workers.PDFConverter

  @behaviour IManagePDFConverterHandler

  # requires ghostscript to be installed first - on mac, install with `brew install ghostscript`
  # -sDEVICE=txtwrite   - text writer
  # -sOutputFile=-      - use stdout instead of a file
  # -q                  - quiet - prevent writing normal messages to output
  # -dNOPAUSE           - disable prompt and pause at end of each page
  # -dBATCH             - indicates batch operation so exits at end of processing
  @ghostscript_args ~w(-sDEVICE=txtwrite -sOutputFile=- -q -dNOPAUSE -dBATCH)
  defp mk_ghostscript_args(input_file) do
    List.insert_at(@ghostscript_args, -1, input_file)
  end

  @impl IManagePDFConverterHandler
  def trigger_pdf_conversion_to_txt(file_path, dest_path, caller) do
    GenServer.cast(
      PDFConverter,
      {:convert, caller: caller, from: file_path, to: dest_path, format: :txt}
    )
  end

  @impl IManagePDFConverterHandler
  def convert_to_txt!(file_path) do
    {txt_content, 0} = System.cmd("gs", mk_ghostscript_args(file_path))
    txt_content
  end
end
