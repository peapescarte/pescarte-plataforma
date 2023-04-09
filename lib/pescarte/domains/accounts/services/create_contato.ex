defmodule Pescarte.Domains.Accounts.Services.CreateContato do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.Models.Contato

  @impl true
  def process(params) do
    with {:ok, changeset} <- Contato.changeset(params) do
      Database.insert_or_update(changeset)
    end
  end
end
