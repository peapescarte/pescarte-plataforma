defmodule Fuschia.ModuloPesquisa.Services.UpdateMidia do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.MidiaRepo
  alias Fuschia.ModuloPesquisa.Models.Midia

  @impl true
  def process(params) do
    params
    |> Midia.new()
    |> MidiaRepo.update()
  end
end
