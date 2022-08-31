defmodule Fuschia.ResearchModulus.Services.GetResearchLine do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchLineRepo

  def process do
    ResearchLineRepo.all()
  end

  @impl true
  def process(nucleo: id) do
    ResearchLineRepo.fetch(id)
  end
end
