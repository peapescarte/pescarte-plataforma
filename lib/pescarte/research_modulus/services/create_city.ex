defmodule Pescarte.ResearchModulus.Services.CreateCity do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.CityRepo

  @impl true
  def process(params) do
    CityRepo.insert(params)
  end
end
