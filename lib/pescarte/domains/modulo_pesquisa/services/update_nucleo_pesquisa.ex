defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateNucleoPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.NucleoPesquisaRepo

  @impl true
  def process(params) do
    with {:ok, nucleo_pesquisa} <- NucleoPesquisaRepo.fetch(params.nucleo_pesquisa_id) do
      NucleoPesquisaRepo.update(nucleo_pesquisa, params)
    end
  end
end
