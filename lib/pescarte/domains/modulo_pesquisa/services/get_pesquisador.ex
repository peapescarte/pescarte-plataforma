defmodule Pescarte.Domains.ModuloPesquisa.Services.GetPesquisador do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.PesquisadorRepo

  def process do
    PesquisadorRepo.all()
  end

  @impl true
  def process(id: id) do
    PesquisadorRepo.fetch(id)
  end
end
