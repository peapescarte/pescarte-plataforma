defmodule Fuschia.ResearchModulus.Services.UpdateResearchCore do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchCoreRepo

  @impl true
  def process(params) do
    with {:ok, core} <- ResearchCoreRepo.fetch(params.core_id) do
      ResearchCoreRepo.update(core, params)
    end
  end
end
