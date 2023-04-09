defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  @impl true
  def process(%{tags: tags} = params) do
    with {:ok, changeset} <- Midia.changeset(params, tags) do
      Database.insert(changeset)
    end
  end
end
