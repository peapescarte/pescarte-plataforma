defmodule Cotacoes.Handlers.IManageFonteHandler do
  alias Cotacoes.Models.Fonte

  @callback insert_fonte_pesagro(String.t()) :: {:ok, Fonte.t()} | {:error, Ecto.Changeset.t()}
  @callback fetch_fonte_pesagro :: {:ok, Fonte.t()} | {:error, :not_found}
end
