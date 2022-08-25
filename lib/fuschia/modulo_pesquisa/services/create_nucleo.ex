defmodule Fuschia.ModuloPesquisa.Services.CreateNucleo do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.NucleoRepo
  alias Fuschia.ModuloPesquisa.Models.Nucleo

  @impl true
  def process(params) do
    params
    |> Nucleo.new()
    |> NucleoRepo.insert()
  end
end
