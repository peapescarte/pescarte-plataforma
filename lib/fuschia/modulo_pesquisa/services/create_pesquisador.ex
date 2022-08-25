defmodule Fuschia.ModuloPesquisa.Services.CreatePesquisador do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.PesquisadorRepo
  alias Fuschia.ModuloPesquisa.Models.Pesquisador

  @impl true
  def process(params) do
    params
    |> Pesquisador.new()
    |> PesquisadorRepo.insert()
  end
end
