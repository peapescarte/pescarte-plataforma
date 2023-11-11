defmodule Pescarte.Cotacoes.Handlers.IManageCotacaoPescadoHandler do
  alias Pescarte.Cotacoes.Models.Cotacao
  alias Pescarte.Cotacoes.Models.CotacaoPescado
  alias Pescarte.Cotacoes.Models.Pescado

  @callback insert_cotacao_pescado(cotacao, pescado, fonte, map) ::
              {:ok, CotacaoPescado.t()} | {:error, Ecto.Changeset.t()}
            when cotacao: Cotacao.t(),
                 pescado: Pescado.t(),
                 fonte: Fonte.t()
end
