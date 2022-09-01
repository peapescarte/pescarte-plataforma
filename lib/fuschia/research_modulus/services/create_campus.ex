defmodule Fuschia.ResearchModulus.Services.CreateCampus do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.CampusRepo

  @impl true
  def process(params) do
    CampusRepo.insert(params)
  end
end
