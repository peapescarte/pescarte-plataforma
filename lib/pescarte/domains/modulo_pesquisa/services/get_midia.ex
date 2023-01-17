defmodule Pescarte.Domains.ModuloPesquisa.Services.GetMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.MidiaRepo

  def process do
    MidiaRepo.all()
  end

  @impl true
  def process(id: id) do
    MidiaRepo.fetch(id)
  end
end
