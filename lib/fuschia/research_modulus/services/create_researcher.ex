defmodule Fuschia.ResearchModulus.Services.CreateResearcher do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.ResearcherRepo
  alias Fuschia.ResearchModulus.Models.Researcher

  @impl true
  def process(params) do
    params
    |> Researcher.new()
    |> ResearcherRepo.insert()
  end
end
