defmodule CotacoesETL.Handlers do
  alias CotacoesETL.Handlers.PDFConverterHandler
  alias CotacoesETL.Handlers.PesagroHandler
  alias CotacoesETL.Handlers.ZIPExtractorHandler

  def pesagro_handler do
    Application.get_env(:cotacoes_etl, :pesagro_handler, PesagroHandler)
  end

  def pdf_converter_handler do
    Application.get_env(:cotacoes_etl, :pdf_converter_handler, PDFConverterHandler)
  end

  def zip_extractor_handler do
    Application.get_env(:cotacoes_etl, :zip_extractor_handler, ZIPExtractorHandler)
  end
end
