defmodule Backend.ResearchModulus.Services.CreateResearchLine do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearchLineRepo

  @impl true
  def process(params) do
    ResearchLineRepo.insert(params)
  end
end
