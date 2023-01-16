defmodule Pescarte.Domains.Accounts.Services.CreateUser do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.IO.UserRepo

  @impl true
  def process(params) do
    UserRepo.insert_pesquisador(params)
  end

  def process(params, :admin) do
    UserRepo.insert_admin(params)
  end
end
