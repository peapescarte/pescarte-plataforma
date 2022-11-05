defmodule Pescarte.ResearchModulus.Services.GetResearchCore do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearchCoreRepo

  def process do
    ResearchCoreRepo.all()
  end

  @impl true
  def process(id: id) do
    ResearchCoreRepo.fetch(id)
  end
end
