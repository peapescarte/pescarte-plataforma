defmodule Pescarte.Domains.ModuloPesquisa.Services.GetMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.MidiaRepo
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def process do
    MidiaRepo.all()
  end

  @impl true
  def process(id: id) do
    MidiaRepo.fetch(id)
  end

  def process(%Tag{} = tag) do
    MidiaRepo.all_by_tag(tag)
  end

  def process(params) do
    MidiaRepo.fetch_by(params)
  end
end
