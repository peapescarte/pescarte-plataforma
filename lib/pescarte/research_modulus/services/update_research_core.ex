defmodule Backend.ResearchModulus.Services.UpdateResearchCore do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearchCoreRepo

  @impl true
  def process(params) do
    with {:ok, core} <- ResearchCoreRepo.fetch(params.core_id) do
      ResearchCoreRepo.update(core, params)
    end
  end
end
