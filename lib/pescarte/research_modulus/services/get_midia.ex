defmodule Pescarte.ResearchModulus.Services.GetMidia do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.MidiaRepo

  def process do
    MidiaRepo.all()
  end

  @impl true
  def process(id: id) do
    MidiaRepo.fetch(id)
  end
end
