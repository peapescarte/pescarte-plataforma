defmodule Pescarte.Domains.ModuloPesquisa.Services.GetCampus do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.CampusRepo

  def process do
    CampusRepo.all()
  end

  @impl true
  def process(municipio: id) do
    CampusRepo.fetch(id)
  end

  def process(params) do
    CampusRepo.fetch_by(params)
  end
end
