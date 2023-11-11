defmodule Pescarte.CotacoesETL.Handlers do
  alias Pescarte.CotacoesETL.Handlers.PDFConverterHandler
  alias Pescarte.CotacoesETL.Handlers.PesagroHandler
  alias Pescarte.CotacoesETL.Handlers.ZIPExtractorHandler

  def pesagro_handler do
    Application.get_env(:pescarte, :pesagro_handler, PesagroHandler)
  end

  def pdf_converter_handler do
    Application.get_env(:pescarte, :pdf_converter_handler, PDFConverterHandler)
  end

  def zip_extractor_handler do
    Application.get_env(:pescarte, :zip_extractor_handler, ZIPExtractorHandler)
  end
end
