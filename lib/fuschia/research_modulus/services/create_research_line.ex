defmodule Fuschia.ResearchModulus.Services.CreateResearchLine do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearchLineRepo
  alias Fuschia.ResearchModulus.Models.ResearchLine

  @impl true
  def process(params) do
    params
    |> ResearchLine.new()
    |> ResearchLineRepo.insert()
  end
end
