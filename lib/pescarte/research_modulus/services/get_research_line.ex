defmodule Backend.ResearchModulus.Services.GetResearchLine do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearchLineRepo

  def process do
    ResearchLineRepo.all()
  end

  @impl true
  def process(nucleo: id) do
    ResearchLineRepo.fetch(id)
  end
end
