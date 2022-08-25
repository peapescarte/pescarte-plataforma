defmodule Fuschia.ModuloPesquisa.Services.CreateMidia do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.MidiaRepo
  alias Fuschia.ModuloPesquisa.Models.Midia

  @impl true
  def process(params) do
    params
    |> Midia.new()
    |> MidiaRepo.insert()
  end
end
