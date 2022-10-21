defmodule Backend.Accounts.Services.CreateUser do
  use Backend, :application_service

  alias Backend.Accounts.IO.UserRepo

  @impl true
  def process(params) do
    UserRepo.insert_researcher(params)
  end

  def process(params, :admin) do
    UserRepo.insert_admin(params)
  end
end
