defmodule Fuschia.ResearchModulus.Services.CreateResearchCore do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchCoreRepo
  alias Fuschia.ResearchModulus.Models.ResearchCore

  @impl true
  def process(params) do
    params
    |> ResearchCore.new()
    |> ResearchCoreRepo.insert()
  end
end
