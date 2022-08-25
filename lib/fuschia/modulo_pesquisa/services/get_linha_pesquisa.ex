defmodule Fuschia.ModuloPesquisa.Services.GetLinhaPesquisa do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.LinhaPesquisaRepo

  def process do
    LinhaPesquisaRepo.all()
  end

  @impl true
  def process(nucleo: id) do
    LinhaPesquisaRepo.fetch(id)
  end
end
