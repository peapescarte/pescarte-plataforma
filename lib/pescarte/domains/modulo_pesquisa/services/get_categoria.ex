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
end
