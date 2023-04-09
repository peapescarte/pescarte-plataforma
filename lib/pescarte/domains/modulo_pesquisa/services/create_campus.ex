defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateCampus do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  @impl true
  def process(params) do
    with {:ok, changeset} <- Campus.changeset(params) do
      Database.insert(changeset)
    end
  end
end
