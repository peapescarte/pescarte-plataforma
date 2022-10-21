defmodule Backend.ResearchModulus.Services.GetCampus do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.CampusRepo

  def process do
    CampusRepo.all()
  end

  @impl true
  def process(municipio: id) do
    CampusRepo.fetch(id)
  end
end
