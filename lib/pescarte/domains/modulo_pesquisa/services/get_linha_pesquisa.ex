defmodule Pescarte.Domains.ModuloPesquisa.Services.GetLinhaPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.LinhaPesquisaRepo

  def process do
    LinhaPesquisaRepo.all()
  end

  @impl true
  def process(nucleo: id) do
    LinhaPesquisaRepo.fetch(id)
  end
end
