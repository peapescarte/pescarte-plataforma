defmodule Fuschia.ResearchModulus.Services.UpdateResearchCore do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchCoreRepo
  alias Fuschia.ResearchModulus.Models.ResearchCore

  @impl true
  def process(params) do
    params
    |> ResearchCore.new()
    |> ResearchCoreRepo.update()
  end
end
