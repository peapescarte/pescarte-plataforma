defmodule Fuschia.ResearchModulus.Services.CreateResearchCore do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchCoreRepo

  @impl true
  def process(params) do
    ResearchCoreRepo.insert(params)
  end
end
