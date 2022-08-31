defmodule Fuschia.Accounts.Services.CreateContact do
  use Fuschia, :application_service

  alias Fuschia.Accounts.IO.ContactRepo
  alias Fuschia.Accounts.Models.Contact

  @impl true
  def process(params) do
    with %Contact{} = contact <- Contact.new(params) do
      ContactRepo.insert_or_update(contact)
    end
  end
end
