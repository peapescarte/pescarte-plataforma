defmodule Pescarte.Domains.Accounts.Services.GetUser do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Services.UserFields

  @impl true
  def process(cpf: cpf, senha: password) do
    user = Database.get_by(User, cpf: cpf)

    if user && UserFields.valid_password?(user, password) do
      {:ok, user}
    else
      {:error, :not_found}
    end
  end

  def process(email: email, password: password) do
    with user = %User{} <- Database.get_by(User, email: email) do
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
    |> User.get_by_email_query()
    |> Database.one()
  end

  def process([]) do
    Database.all(User)
  end

  def process(params) do
    cond do
      Enum.all?(params, &is_tuple/1) ->
        Database.get_by(User, params)

      Enum.all?(params, &is_atom/1) ->
        params
        |> User.list_by_query()
        |> Database.all()

      true ->
        {:error, :invalid_args}
    end
  end
end
