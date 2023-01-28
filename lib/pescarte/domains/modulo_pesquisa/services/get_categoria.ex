defmodule Pescarte.Domains.ModuloPesquisa.Services.GetCategoria do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.CategoriaRepo

  def process do
    CategoriaRepo.all()
  end

  @impl true
  def process(id: id) do
    CategoriaRepo.fetch(id)
  end

  def process(params) do
    CategoriaRepo.fetch_by(params)
  end
end
