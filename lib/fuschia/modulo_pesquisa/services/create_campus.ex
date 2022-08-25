defmodule Fuschia.ModuloPesquisa.Services.CreateCampus do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.CampusRepo
  alias Fuschia.ModuloPesquisa.Models.Campus

  @impl true
  def process(params) do
    params
    |> Campus.new()
    |> CampusRepo.insert()
  end
end
