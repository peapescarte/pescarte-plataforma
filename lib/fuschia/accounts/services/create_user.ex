defmodule Fuschia.Accounts.Services.CreateUser do
  use Fuschia, :application_service

  alias Fuschia.Accounts.IO.UserRepo

  @impl true
  def process(params) do
    UserRepo.insert_researcher(params)
  end

  def process(params, :admin) do
    UserRepo.insert_admin(params)
  end
end
