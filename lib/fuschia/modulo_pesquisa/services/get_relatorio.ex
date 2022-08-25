defmodule Fuschia.ModuloPesquisa.Services.GetRelatorio do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.RelatorioRepo

  def process do
    RelatorioRepo.all()
  end

  @impl true
  def process(id: id) do
    RelatorioRepo.fetch(id)
  end
end
