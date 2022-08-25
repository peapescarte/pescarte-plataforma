defmodule Fuschia.ModuloPesquisa.Services.CreateCidade do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.CidadeRepo
  alias Fuschia.ModuloPesquisa.Models.Cidade

  @impl true
  def process(params) do
    params
    |> Cidade.new()
    |> CidadeRepo.insert()
  end
end
