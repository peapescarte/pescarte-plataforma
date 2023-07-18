defmodule Cotacoes.Handlers.PescadoHandler do
  alias Cotacoes.Handlers.IManagePescadoHandler
  alias Cotacoes.Repository

  @behaviour IManagePescadoHandler

  @impl true
  def insert_pescado(codigo) do
    Repository.upsert_pescado(%{codigo: codigo})
  end

  @impl true
  def fetch_or_insert_pescado(codigo) do
    case Repository.fetch_pescado_by_codigo(codigo) do
      {:ok, pescado} -> {:ok, pescado}
      {:error, :not_found} -> insert_pescado(codigo)
    end
  end
end
