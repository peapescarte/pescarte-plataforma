defmodule Pescarte.Domains.ModuloPesquisa.Services.CreatePesquisador do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.PesquisadorRepo

  @impl true
  def process(params) do
    PesquisadorRepo.insert(params)
  end
end
