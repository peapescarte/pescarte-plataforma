defmodule Pescarte.ResearchModulus.Services.CreateCampus do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.CampusRepo

  @impl true
  def process(params) do
    CampusRepo.insert(params)
  end
end
