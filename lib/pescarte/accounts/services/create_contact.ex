defmodule Backend.Accounts.Services.CreateContact do
  use Backend, :application_service

  alias Backend.Accounts.IO.ContactRepo

  @impl true
  def process(params) do
    ContactRepo.insert_or_update(params)
  end
end
