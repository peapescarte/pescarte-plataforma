defmodule Backend.ResearchModulus.Services.GetCity do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.CityRepo

  @impl true
  def process(id: id) do
    CityRepo.fetch(id)
  end
end
