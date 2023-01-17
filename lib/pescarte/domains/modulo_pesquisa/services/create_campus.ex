defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateCampus do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.CampusRepo

  @impl true
  def process(params) do
    CampusRepo.insert(params)
  end
end
