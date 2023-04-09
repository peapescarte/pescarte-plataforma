defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateNucleoPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa

  @impl true
  def process(params) do
    with {:ok, changeset} <- NucleoPesquisa.changeset(params) do
      Database.insert(changeset)
    end
  end
end
