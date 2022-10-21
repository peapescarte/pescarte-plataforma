defmodule Backend.ResearchModulus.Services.GetResearcher do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearcherRepo

  def process do
    ResearcherRepo.all()
  end

  @impl true
  def process(id: id) do
    ResearcherRepo.fetch(id)
  end
end
