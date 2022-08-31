defmodule Fuschia.ResearchModulus.Services.UpdateMidia do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MidiaRepo
  alias Fuschia.ResearchModulus.Models.Midia

  @impl true
  def process(params) do
    params
    |> Midia.new()
    |> MidiaRepo.update()
  end
end
