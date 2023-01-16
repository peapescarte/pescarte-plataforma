defmodule Pescarte.Domains.ModuloPesquisa.Services.GetRelatorioMensal do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.RelatorioMensalRepo

  def process do
    RelatorioMensalRepo.all()
  end

  @impl true
  def process(id: id) do
    RelatorioMensalRepo.fetch(id)
  end
end
