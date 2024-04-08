defmodule Pescarte.Cotacoes.Handlers.IManageCotacaoHandler do
  alias Pescarte.Cotacoes.Models.Cotacao

  @callback zip_file?(Cotacao.t()) :: boolean
  @callback fetch_cotacao_by_id(String.t()) :: {:ok, Cotacao.t()} | {:error, :not_found}
  @callback find_cotacoes_not_ingested :: list(Cotacao.t())
  @callback find_cotacoes_not_downloaded :: list(Cotacao.t())
  @callback fetch_cotacao_by_link(String.t()) :: {:ok, Cotacao.t()} | {:error, :not_found}
  @callback get_cotacao_file_base_name(Cotacao.t()) :: String.t()
  @callback insert_cotacao_pesagro(String.t(), Date.t()) ::
              {:ok, Cotacao.t()} | {:error, Ecto.Changeset.t()}
  @callback list_cotacao :: list(Cotacao.t())
  @callback set_cotacao_downloaded(Cotacao.t()) ::
              {:ok, Cotacao.t()} | {:error, Ecto.Changeset.t()}
end
