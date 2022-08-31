defmodule Fuschia.ResearchModulus.Services.CreateCity do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.CityRepo
  alias Fuschia.ResearchModulus.Models.City

  @impl true
  def process(params) do
    params
    |> City.new()
    |> CityRepo.insert()
  end
end
