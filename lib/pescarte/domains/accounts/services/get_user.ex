defmodule Pescarte.Domains.Accounts.Services.GetUser do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.IO.UserRepo
  alias Pescarte.Domains.Accounts.Services.UserFields

  @impl true
  def process(cpf: cpf) do
    with {:ok, user} <- UserRepo.fetch_by(cpf: cpf) do
      {:ok, UserFields.put_permissions(user)}
    end
  end

  def process(id: id) do
    with {:ok, user} <- UserRepo.fetch(id) do
      {:ok, UserFields.put_permissions(user)}
    end
  end

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

  def process(args) do
    if Enum.all?(args, &is_atom/1) do
      UserRepo.all(args)
    else
      process(args)
    end
  end
end
