defmodule Backend.ResearchModulus.Services.GetMidia do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.MidiaRepo

  def process do
    MidiaRepo.all()
  end

  @impl true
  def process(id: id) do
    MidiaRepo.fetch(id)
  end
end
