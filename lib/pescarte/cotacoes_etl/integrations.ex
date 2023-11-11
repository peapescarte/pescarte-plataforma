defmodule Pescarte.CotacoesETL.Integrations do
  alias Pescarte.CotacoesETL.Integrations.PesagroAPI

  def pesagro_api do
    Application.get_env(:pescarte, :pesagro_api, PesagroAPI)
  end
end
