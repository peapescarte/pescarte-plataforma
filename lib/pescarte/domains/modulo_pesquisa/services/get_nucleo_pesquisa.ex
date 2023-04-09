defmodule Pescarte.Domains.ModuloPesquisa.Services.GetNucleoPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa

  def process do
    Database.all(NucleoPesquisa)
  end

  @impl true
  def process(id: id) do
    Database.get(NucleoPesquisa, id)
  end
end
