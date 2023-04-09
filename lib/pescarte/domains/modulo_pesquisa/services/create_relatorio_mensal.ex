defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateRelatorioMensal do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @impl true
  def process(params) do
    with {:ok, changeset} <- RelatorioMensal.changeset(params) do
      Database.insert(changeset)
    end
  end
end
