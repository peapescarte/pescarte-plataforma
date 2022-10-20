defmodule Pescarte.ResearchModulus.Services.CreateResearchCore do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.ResearchCoreRepo

  @impl true
  def process(params) do
    ResearchCoreRepo.insert(params)
  end
end
