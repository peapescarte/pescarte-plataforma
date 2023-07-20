defmodule Cotacoes.Handlers.IManageCotacaoPescadoHandler do
  alias Cotacoes.Models.Cotacao
  alias Cotacoes.Models.CotacaoPescado
  alias Cotacoes.Models.Pescado

  @callback insert_cotacao_pescado(cotacao, pescado, fonte, map) ::
              {:ok, CotacaoPescado.t()} | {:error, Ecto.Changeset.t()}
            when cotacao: Cotacao.t(),
                 pescado: Pescado.t(),
                 fonte: Fonte.t()
end
