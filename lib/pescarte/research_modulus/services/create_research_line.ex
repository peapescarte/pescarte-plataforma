defmodule Pescarte.ResearchModulus.Services.CreateResearchLine do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearchLineRepo

  @impl true
  def process(params) do
    ResearchLineRepo.insert(params)
  end
end
