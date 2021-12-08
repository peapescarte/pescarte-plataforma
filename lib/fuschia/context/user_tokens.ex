defmodule Fuschia.Context.UserTokens do
  @moduledoc """
  Public Fuschia UserTOken API
  """

  import Ecto.Query

  alias Fuschia.Entities.UserToken

  @type user :: %Fuschia.Entities.User{}

  @hash_algorithm :sha256

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the email may take over the account.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 5
  @change_email_validity_in_days 5

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the user found by the token.
  """
  @spec verify_email_token_query(String.t(), String.t()) :: {:ok, Ecto.Query.t()} | :error
  def verify_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = days_for_context(context)

        query =
          from token in token_and_context_query(hashed_token, context),
            join: user in assoc(token, :user),
            join: contato in assoc(user, :contato),
            where: token.inserted_at > ago(^days, "day") and token.sent_to == contato.email,
            select: user

        {:ok, query}

      :error ->
        :error
    end
  end

  defp days_for_context("confirm"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the user token record.
  """
  @spec verify_change_email_token_query(String.t(), String.t()) :: {:ok, Ecto.Query.t()} | :error
  def verify_change_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        query =
          from token in token_and_context_query(hashed_token, context),
            where: token.inserted_at > ago(@change_email_validity_in_days, "day")

        {:ok, query}

      :error ->
        :error
    end
  end

  @doc """
  Returns the given token with the given context.
  """
  @spec token_and_context_query(String.t(), String.t()) :: Ecto.Query.t()
  def token_and_context_query(token, context) do
    from UserToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Gets all tokens for the given user for the given contexts.
  """
  @spec user_and_contexts_query(user, list | :all) :: Ecto.Query.t()
  def user_and_contexts_query(user, :all) do
    from t in UserToken, where: t.user_cpf == ^user.cpf
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in UserToken, where: t.user_cpf == ^user.cpf and t.context in ^contexts
  end
end
