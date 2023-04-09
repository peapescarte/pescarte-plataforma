defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateTag do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @impl true
  def process(params) do
    with {:ok, changeset} <- Tag.changeset(params) do
      Database.insert(changeset)
    end
  end
end
