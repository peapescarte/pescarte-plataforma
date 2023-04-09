defmodule Pescarte.Domains.ModuloPesquisa.Services.GetCampus do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  def process do
    Database.all(Campus)
  end

  @impl true
  def process(id: id) do
    Database.get(Campus, id)
  end

  def process(params) do
    Database.get_by(Campus, params)
  end
end
