defmodule Pescarte.ResearchModulus.Services.GetCampus do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.CampusRepo

  def process do
    CampusRepo.all()
  end

  @impl true
  def process(municipio: id) do
    CampusRepo.fetch(id)
  end
end
