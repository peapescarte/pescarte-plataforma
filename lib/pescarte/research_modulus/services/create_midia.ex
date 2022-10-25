defmodule Pescarte.ResearchModulus.Services.CreateMidia do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.MidiaRepo

  @impl true
  def process(params) do
    MidiaRepo.insert(params)
  end
end
