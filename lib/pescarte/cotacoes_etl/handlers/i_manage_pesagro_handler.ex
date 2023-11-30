defmodule Pescarte.CotacoesETL.Handlers.IManagePesagroHandler do
  alias Pescarte.Cotacoes.Models.Cotacao

  @callback download_cotacao_from_pesagro!(Path.t(), Cotacao.t()) :: Path.t()
end
