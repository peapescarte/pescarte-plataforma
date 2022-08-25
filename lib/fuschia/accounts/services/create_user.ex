defmodule Fuschia.Accounts.Services.CreateUser do
  use Fuschia, :application_service

  alias Fuschia.Accounts.IO.UserRepo
  alias Fuschia.Accounts.Models.User

  @impl true
  def process(params) do
    params
    |> User.new()
    |> UserRepo.insert_researcher()
  end

  def process(params, :admin) do
    params
    |> User.new()
    |> UserRepo.insert_admin()
  end
end
