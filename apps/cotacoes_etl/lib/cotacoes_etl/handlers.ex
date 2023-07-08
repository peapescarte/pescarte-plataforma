defmodule CotacoesETL.Handlers do
  alias CotacoesETL.Handlers.PesagroHandler
  alias CotacoesETL.Handlers.ZamzarHandler

  def pesagro_handler do
    Application.get_env(:cotacoes_etl, :pesagro_handler, PesagroHandler)
  end

  def zamzar_handler do
    Application.get_env(:cotacoes_etl, :zamzar_handler, ZamzarHandler)
  end
end
