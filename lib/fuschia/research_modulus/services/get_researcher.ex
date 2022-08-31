defmodule Fuschia.ResearchModulus.Services.GetResearcher do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearcherRepo

  def process do
    ResearcherRepo.all()
  end

  @impl true
  def process(id: id) do
    ResearcherRepo.fetch(id)
  end
end
