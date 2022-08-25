defmodule Fuschia.ModuloPesquisa.Services.GetPesquisador do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.PesquisadorRepo

  def process do
    PesquisadorRepo.all()
  end

  @impl true
  def process(id: id) do
    PesquisadorRepo.fetch(id)
  end
end
