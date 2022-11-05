defmodule Pescarte.ResearchModulus.Services.UpdateMidia do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.MidiaRepo

  @impl true
  def process(params) do
    with {:ok, midia} <- MidiaRepo.fetch(params.midia_id) do
      MidiaRepo.update(midia, params)
    end
  end
end
