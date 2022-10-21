defmodule Backend.ResearchModulus.Services.GetResearchCore do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearchCoreRepo

  def process do
    ResearchCoreRepo.all()
  end

  @impl true
  def process(id: id) do
    ResearchCoreRepo.fetch(id)
  end
end
