defmodule Fuschia.ResearchModulus.Services.GetResearchCore do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchCoreRepo

  def process do
    ResearchCoreRepo.all()
  end

  @impl true
  def process(id: id) do
    ResearchCoreRepo.fetch(id)
  end
end
