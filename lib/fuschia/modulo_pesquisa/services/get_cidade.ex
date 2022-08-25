defmodule Fuschia.ModuloPesquisa.Services.GetCidade do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.CidadeRepo

  @impl true
  def process(id: id) do
    CidadeRepo.fetch(id)
  end
end
