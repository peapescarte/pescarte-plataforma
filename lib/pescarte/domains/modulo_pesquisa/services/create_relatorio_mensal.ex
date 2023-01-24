defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateRelatorioMensal do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.RelatorioMensalRepo

  @impl true
  def process(params) do
    RelatorioMensalRepo.insert(params)
  end
end
