defmodule Pescarte.ResearchModulus.Services.GetResearcher do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearcherRepo

  def process do
    ResearcherRepo.all()
  end

  @impl true
  def process(id: id) do
    ResearcherRepo.fetch(id)
  end
end
