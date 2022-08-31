defmodule Fuschia.ResearchModulus.Services.CreateCampus do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.CampusRepo
  alias Fuschia.ResearchModulus.Models.Campus

  @impl true
  def process(params) do
    params
    |> Campus.new()
    |> CampusRepo.insert()
  end
end
