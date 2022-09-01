defmodule Fuschia.ResearchModulus.Services.CreateCity do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.CityRepo

  @impl true
  def process(params) do
    CityRepo.insert(params)
  end
end
