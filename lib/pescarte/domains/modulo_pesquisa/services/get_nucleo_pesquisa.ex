defmodule Pescarte.Domains.ModuloPesquisa.Services.GetNucleoPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.NucleoPesquisaRepo

  def process do
    NucleoPesquisaRepo.all()
  end

  @impl true
  def process(id: id) do
    NucleoPesquisaRepo.fetch(id)
  end
end
