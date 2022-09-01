defmodule Fuschia.ResearchModulus.Services.CreateResearchLine do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchLineRepo

  @impl true
  def process(params) do
    ResearchLineRepo.insert(params)
  end
end
