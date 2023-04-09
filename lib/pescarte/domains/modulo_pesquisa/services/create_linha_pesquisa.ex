defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateLinhaPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  @impl true
  def process(params) do
    with {:ok, changeset} <- LinhaPesquisa.changeset(params) do
      Database.insert(changeset)
    end
  end
end
