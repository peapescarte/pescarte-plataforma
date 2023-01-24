defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateNucleoPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.NucleoPesquisaRepo

  @impl true
  def process(params) do
    NucleoPesquisaRepo.insert(params)
  end
end
