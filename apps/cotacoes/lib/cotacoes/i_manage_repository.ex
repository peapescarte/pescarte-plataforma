defmodule Cotacoes.IManageRepository do
  alias Cotacoes.Models.Cotacao
  alias Cotacoes.Models.CotacaoPescado
  alias Cotacoes.Models.Pescado

  @opaque changeset :: Ecto.Changeset.t()

  @callback find_all_cotacao_by_not_ingested :: list(Cotacao.t())
  @callback find_all_cotacao_by_not_downloaded :: list(Cotacao.t())
  @callback fetch_cotacao_by_link(String.t()) :: {:ok, Cotacao.t()} | {:error, :not_found}
  @callback insert_all_cotacao(list(map)) :: :ok
  @callback list_cotacao :: list(Cotacao.t())
  @callback update_all_cotacao(list(Cotacao.t()), keyword) :: {:ok, list(Cotacao.t()) | nil}
  @callback upsert_cotacao(map) :: {:ok, Cotacao.t()} | {:error, changeset}

  @callback upsert_cotacao_pescado(map) :: {:ok, CotacaoPescado.t()} | {:error, changeset}

  @callback insert_all_pescado(list(Pescadot.t())) :: :ok
  @callback list_pescado :: list(Pescado.t())
  @callback upsert_pescado(map) :: {:ok, Pescado.t()} | {:error, changeset}
end
