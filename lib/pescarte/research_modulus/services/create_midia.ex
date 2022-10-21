defmodule Backend.ResearchModulus.Services.CreateMidia do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.MidiaRepo

  @impl true
  def process(params) do
    MidiaRepo.insert(params)
  end
end
