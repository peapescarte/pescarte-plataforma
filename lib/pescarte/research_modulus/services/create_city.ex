defmodule Backend.ResearchModulus.Services.CreateCity do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.CityRepo

  @impl true
  def process(params) do
    CityRepo.insert(params)
  end
end
