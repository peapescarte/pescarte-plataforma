defmodule Fuschia.ResearchModulus.Services.GetMidia do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MidiaRepo

  def process do
    MidiaRepo.all()
  end

  @impl true
  def process(id: id) do
    MidiaRepo.fetch(id)
  end
end
