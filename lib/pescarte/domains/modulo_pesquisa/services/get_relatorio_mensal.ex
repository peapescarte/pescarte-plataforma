defmodule Pescarte.Domains.ModuloPesquisa.Services.GetRelatorioMensal do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  def process do
    Database.all(RelatorioMensal)
  end

  @impl true
  def process(id: id) do
    Database.get(RelatorioMensal, id)
  end
end
