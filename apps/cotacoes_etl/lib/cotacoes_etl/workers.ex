defmodule CotacoesETL.Workers do
  alias CotacoesETL.Workers.PDFConverter
  alias CotacoesETL.Workers.ZIPExtractor

  def pdf_converter_worker do
    Application.get_env(:cotacoes_etl, :pdf_converter_worker, PDFConverter)
  end

  def zip_extractor_worker do
    Application.get_env(:cotacoes_etl, :zip_extractor_worker, ZIPExtractor)
  end
end
