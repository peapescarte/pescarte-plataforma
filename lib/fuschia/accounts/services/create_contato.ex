defmodule Fuschia.Accounts.Services.CreateContato do
  use Fuschia, :application_service

  alias Fuschia.Accounts.IO.ContatoRepo
  alias Fuschia.Accounts.Models.Contato

  @impl true
  def process(params) do
    with %Contato{} = contact <- Contato.new(params) do
      ContatoRepo.insert_or_update(contact)
    end
  end
end
