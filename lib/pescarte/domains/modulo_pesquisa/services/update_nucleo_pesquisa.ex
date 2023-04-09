defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateNucleoPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa, as: NP

  @impl true
  def process(%{nucleo_pesquisa_id: id} = params) do
    with nucleo_pesquisa = %NP{} <- Database.get(NP, id),
         {:ok, changeset} <- NP.update_changeset(nucleo_pesquisa, params) do
      Database.update(changeset)
    end
  end
end
