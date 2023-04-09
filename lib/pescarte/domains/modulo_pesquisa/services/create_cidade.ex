defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateCidade do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade

  @impl true
  def process(params) do
    with {:ok, changeset} <- Cidade.changeset(params) do
      Database.insert(changeset)
    end
  end
end
