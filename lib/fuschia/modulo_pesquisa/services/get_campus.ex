defmodule Fuschia.ModuloPesquisa.Services.GetCampus do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.CampusRepo

  def process do
    CampusRepo.all()
  end

  @impl true
  def process(municipio: id) do
    CampusRepo.fetch(id)
  end
end
