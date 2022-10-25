defmodule Pescarte.ResearchModulus.Services.GetResearchLine do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearchLineRepo

  def process do
    ResearchLineRepo.all()
  end

  @impl true
  def process(nucleo: id) do
    ResearchLineRepo.fetch(id)
  end
end
