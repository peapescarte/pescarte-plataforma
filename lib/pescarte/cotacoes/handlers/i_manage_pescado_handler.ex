defmodule Pescarte.Cotacoes.Handlers.IManagePescadoHandler do
  alias Pescarte.Cotacoes.Models.Pescado

  @callback insert_pescado(String.t()) :: {:ok, Pescado.t()} | {:error, Ecto.Changeset.t()}
  @callback fetch_or_insert_pescado(String.t()) ::
              {:ok, Pescado.t()} | {:error, Ecto.Changeset.t()}
end
