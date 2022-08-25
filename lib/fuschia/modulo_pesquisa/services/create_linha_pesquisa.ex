defmodule Fuschia.ModuloPesquisa.Services.CreateLinhaPesquisa do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.LinhaPesquisaRepo
  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa

  @impl true
  def process(params) do
    params
    |> LinhaPesquisa.new()
    |> LinhaPesquisaRepo.insert()
  end
end
