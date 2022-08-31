defmodule Fuschia.ResearchModulus.Services.CreateMidia do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MidiaRepo
  alias Fuschia.ResearchModulus.Models.Midia

  @impl true
  def process(params) do
    params
    |> Midia.new()
    |> MidiaRepo.insert()
  end
end
