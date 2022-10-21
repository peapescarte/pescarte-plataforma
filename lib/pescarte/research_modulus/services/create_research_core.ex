defmodule Backend.ResearchModulus.Services.CreateResearchCore do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearchCoreRepo

  @impl true
  def process(params) do
    ResearchCoreRepo.insert(params)
  end
end
