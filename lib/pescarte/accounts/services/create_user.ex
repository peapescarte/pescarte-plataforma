defmodule Pescarte.Accounts.Services.CreateUser do
  use Pescarte, :application_service

  alias Pescarte.Accounts.IO.UserRepo

  @impl true
  def process(params) do
    UserRepo.insert_researcher(params)
  end

  def process(params, :admin) do
    UserRepo.insert_admin(params)
  end
end
