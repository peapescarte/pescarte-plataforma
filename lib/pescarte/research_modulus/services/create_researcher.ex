defmodule Pescarte.ResearchModulus.Services.CreateResearcher do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearcherRepo

  @impl true
  def process(params) do
    ResearcherRepo.insert(params)
  end
end
