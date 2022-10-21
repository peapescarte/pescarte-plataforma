defmodule Backend.ResearchModulus.Services.UpdateMidia do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.MidiaRepo

  @impl true
  def process(params) do
    with {:ok, midia} <- MidiaRepo.fetch(params.midia_id) do
      MidiaRepo.update(midia, params)
    end
  end
end
