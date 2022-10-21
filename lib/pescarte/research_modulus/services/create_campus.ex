defmodule Backend.ResearchModulus.Services.CreateCampus do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.CampusRepo

  @impl true
  def process(params) do
    CampusRepo.insert(params)
  end
end
