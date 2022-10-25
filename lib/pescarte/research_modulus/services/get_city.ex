defmodule Pescarte.ResearchModulus.Services.GetCity do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.CityRepo

  @impl true
  def process(id: id) do
    CityRepo.fetch(id)
  end
end
