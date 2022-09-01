defmodule Fuschia.ResearchModulus.Services.CreateResearcher do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearcherRepo

  @impl true
  def process(params) do
    ResearcherRepo.insert(params)
  end
end
