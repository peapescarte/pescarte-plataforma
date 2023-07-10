defmodule CotacoesETL.Handlers do
  alias CotacoesETL.Handlers.PesagroHandler

  def pesagro_handler do
    Application.get_env(:cotacoes_etl, :pesagro_handler, PesagroHandler)
  end
end
