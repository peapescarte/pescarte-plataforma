defmodule Pescarte.Accounts.Services.CreateContact do
  use Pescarte, :application_service

  alias Pescarte.Accounts.IO.ContactRepo

  @impl true
  def process(params) do
    ContactRepo.insert_or_update(params)
  end
end
