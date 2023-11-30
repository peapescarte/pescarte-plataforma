defmodule Pescarte.Cotacoes.IManageRepository do
  alias Pescarte.Cotacoes.Models.Cotacao
  alias Pescarte.Cotacoes.Models.CotacaoPescado
  alias Pescarte.Cotacoes.Models.Fonte
  alias Pescarte.Cotacoes.Models.Pescado

  @opaque changeset :: Ecto.Changeset.t()

  @callback find_all_cotacao_by_not_ingested :: list(Cotacao.t())
  @callback find_all_cotacao_by_not_downloaded :: list(Cotacao.t())
  @callback fetch_cotacao_by_link(String.t()) :: {:ok, Cotacao.t()} | {:error, :not_found}
  @callback fetch_cotacao_by_id(String.t()) :: {:ok, Cotacao.t()} | {:error, :not_found}
  @callback insert_cotacao(map) :: {:ok, Cotacao.t()} | {:error, changeset}
  @callback list_cotacao :: list(Cotacao.t())
  @callback upsert_cotacao(map) :: {:ok, Cotacao.t()} | {:error, changeset}

  @callback fetch_cotacao_pescado_by(keyword) :: {:ok, CotacaoPescado.t()} | {:error, changeset}
  @callback upsert_cotacao_pescado(map) :: {:ok, CotacaoPescado.t()} | {:error, changeset}

  @callback insert_all_pescado(list(Pescadot.t())) :: :ok
  @callback fetch_pescado_by_codigo(String.t()) :: {:ok, Pescado.t()} | {:error, :not_found}
  @callback list_pescado :: list(Pescado.t())
  @callback upsert_pescado(map) :: {:ok, Pescado.t()} | {:error, changeset}

  @callback fetch_fonte_by_nome(String.t()) :: {:ok, Fonte.t()} | {:error, :not_found}
  @callback insert_fonte_cotacao(map) :: {:ok, Fonte.t()} | {:error, changeset}
end
