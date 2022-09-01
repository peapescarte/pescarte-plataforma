defmodule Fuschia.Accounts.Services.CreateContact do
  use Fuschia, :application_service

  alias Fuschia.Accounts.IO.ContactRepo

  @impl true
  def process(params) do
    ContactRepo.insert_or_update(params)
  end
end
