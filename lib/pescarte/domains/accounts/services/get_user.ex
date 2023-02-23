defmodule Pescarte.Domains.Accounts.Services.GetUser do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.IO.UserRepo
  alias Pescarte.Domains.Accounts.Services.UserFields

  @impl true
  def process(cpf: cpf, password: password) do
    with {:ok, user} <- UserRepo.fetch_by(cpf: cpf) do
      if UserFields.valid_password?(user, password) do
        {:ok, user}
      else
        {:error, :not_found}
      end
    end
  end

  def process(email: email, password: password) do
    with {:ok, user} <- UserRepo.fetch_by(email: email) do
      if UserFields.valid_password?(user, password) do
        {:ok, user}
      else
        {:error, :not_found}
      end
    end
  end

  def process(email: email) when is_binary(email) do
    email
    |> String.downcase()
    |> String.trim()
    |> UserRepo.fetch_by_email()
  end

  def process([]) do
    UserRepo.all()
  end

  def process(args) do
    cond do
      Enum.all?(args, &is_tuple/1) ->
        UserRepo.fetch_by(args)

      Enum.all?(args, &is_atom/1) ->
        UserRepo.all(args)

      true ->
        {:error, :invalid_args}
    end
  end
end
