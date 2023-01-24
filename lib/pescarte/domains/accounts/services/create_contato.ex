defmodule Pescarte.Domains.Accounts.Services.CreateContato do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.IO.ContatoRepo

  @impl true
  def process(params) do
    ContatoRepo.insert_or_update(params)
  end
end
