defmodule Pescarte.ModuloPesquisa.Handlers.CeletistaHandler do
  alias Pescarte.ModuloPesquisa.Adapters.CeletistaAdapter
  alias Pescarte.ModuloPesquisa.Models.Celetista
  alias Pescarte.ModuloPesquisa.Repository

  def list_celetistas(params \\ %{}) do
    with {:ok, flop} <- Flop.validate(params, for: Celetista),
         {data, meta} <- Repository.list_celetista(flop) do
      data = Enum.map(data, &CeletistaAdapter.internal_to_external/1)
      {:ok, {data, meta}}
    end
  end
end
