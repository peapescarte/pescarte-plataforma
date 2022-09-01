defmodule Fuschia.ResearchModulus.Services.UpdateMidia do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MidiaRepo

  @impl true
  def process(params) do
    with {:ok, midia} <- MidiaRepo.fetch(params.midia_id) do
      MidiaRepo.update(midia, params)
    end
  end
end
