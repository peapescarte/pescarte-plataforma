defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateCategoria do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.CategoriaRepo

  @impl true
  def process(params) do
    CategoriaRepo.insert(params)
  end
end
