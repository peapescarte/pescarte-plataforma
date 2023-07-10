defmodule Cotacoes.Handlers.IManageCotacaoHandler do
  alias Cotacoes.Models.Cotacao

  @callback find_cotacoes_not_ingested :: list(Cotacao.t())
  @callback find_cotacoes_not_downloaded :: list(Cotacao.t())
  @callback get_cotacao_file_base_name(Cotacao.t()) :: String.t()
  @callback ingest_cotacoes(list(Cotacao.t())) :: :ok
  @callback insert_cotacoes!(list(Cotacao.t())) :: :ok
  @callback list_cotacao :: list(Cotacao.t())
  @callback reject_inserted_cotacoes(list(Cotacao.t())) :: list(Cotacao.t())
  @callback set_cotacao_downloaded(Cotacao.t()) ::
              {:ok, Cotacao.t()} | {:error, Ecto.Changeset.t()}
end
