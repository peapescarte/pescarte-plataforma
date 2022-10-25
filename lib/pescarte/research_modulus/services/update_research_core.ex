defmodule Pescarte.ResearchModulus.Services.UpdateResearchCore do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearchCoreRepo

  @impl true
  def process(params) do
    with {:ok, core} <- ResearchCoreRepo.fetch(params.core_id) do
      ResearchCoreRepo.update(core, params)
    end
  end
end
