defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateLinhaPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.LinhaPesquisaRepo

  @impl true
  def process(params) do
    LinhaPesquisaRepo.insert(params)
  end
end
