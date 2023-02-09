defmodule Pescarte.Domains.ModuloPesquisa.Services.GetCidade do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.CidadeRepo

  @impl true
  def process(id: id) do
    CidadeRepo.fetch(id)
  end

  def process(params) do
    CidadeRepo.fetch_by(params)
  end
end
