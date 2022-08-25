defmodule Fuschia.ModuloPesquisa.Services.CreateRelatorio do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.RelatorioRepo
  alias Fuschia.ModuloPesquisa.Models.Relatorio

  @impl true
  def process(params) do
    params
    |> Relatorio.new()
    |> RelatorioRepo.insert()
  end
end
