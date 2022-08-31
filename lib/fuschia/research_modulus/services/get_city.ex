defmodule Fuschia.ResearchModulus.Services.GetCity do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.CityRepo

  @impl true
  def process(id: id) do
    CityRepo.fetch(id)
  end
end
