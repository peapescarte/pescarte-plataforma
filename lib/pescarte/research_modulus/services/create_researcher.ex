defmodule Backend.ResearchModulus.Services.CreateResearcher do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.ResearcherRepo

  @impl true
  def process(params) do
    ResearcherRepo.insert(params)
  end
end
