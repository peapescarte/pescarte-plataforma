defmodule CotacoesETL.Integrations do
  alias CotacoesETL.Integrations.PesagroAPI
  alias CotacoesETL.Integrations.ZamzarAPI

  def pesagro_api do
    Application.get_env(:cotacoes_etl, :pesagro_api, PesagroAPI)
  end

  def zamzar_api do
    Application.get_env(:cotacoes_etl, :zamzar_api, ZamzarAPI)
  end
end
