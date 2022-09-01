defmodule Fuschia.ResearchModulus.Services.CreateMidia do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MidiaRepo

  @impl true
  def process(params) do
    MidiaRepo.insert(params)
  end
end
