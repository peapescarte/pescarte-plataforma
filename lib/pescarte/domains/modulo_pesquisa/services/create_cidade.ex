defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateCidade do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.CidadeRepo

  @impl true
  def process(params) do
    CidadeRepo.insert(params)
  end
end
