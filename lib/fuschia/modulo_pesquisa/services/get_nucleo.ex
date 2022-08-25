defmodule Fuschia.ModuloPesquisa.Services.GetNucleo do
  use Fuschia, :application_service

  alias Fuschia.ModuloPesquisa.IO.NucleoRepo

  def process do
    NucleoRepo.all()
  end

  @impl true
  def process(id: id) do
    NucleoRepo.fetch(id)
  end
end
