defmodule Pescarte.Domains.ModuloPesquisa.Services.CreatePesquisador do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @impl true
  def process(params) do
    with {:ok, changeset} <- Pesquisador.changeset(params) do
      Database.insert(changeset)
    end
  end
end
