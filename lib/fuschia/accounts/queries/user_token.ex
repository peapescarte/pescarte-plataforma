defmodule Fuschia.Accounts.Queries.UserToken do
  @moduledoc false

  import Ecto.Query

  alias Fuschia.Accounts.Models.UserToken

  @hash_algorithm :sha256

  # É muito importante manter a expiração do token de redefinição de senha curta,
  # já que alguém com acesso ao e-mail pode assumir a conta.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  @doc """
  Verifica se o token é válido e retorna sua consulta de pesquisa subjacente.

  A consulta retorna o usuário encontrado pelo token, se houver.

  O token é válido se corresponder ao valor no banco de dados e tiver
  não expirou (após @session_validity_in_days).
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end

  @doc """
  Verifica se o token é válido e retorna sua consulta de pesquisa subjacente.

  A consulta retorna o usuário encontrado pelo token, se houver.

  O token fornecido é válido se corresponder à sua contraparte com hash no
  banco de dados e o e-mail do usuário não foi alterado. Esta função também verifica
  se o token estiver sendo usado dentro de um determinado período, dependendo do
  contexto. Os contextos padrão suportados por esta função são
  "confirm", para e-mails de confirmação de conta, e "reset_password",
  para redefinir a senha. Para verificar solicitações de alteração de e-mail,
  veja `verify_change_email_token_query/2`.
  """
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
  Verifica se o token é válido e retorna sua consulta de pesquisa subjacente.

  A consulta retorna o usuário encontrado pelo token, se houver.

  Isso é usado para validar solicitações para alterar o usuário
  o email. É diferente de `verify_email_token_query/2` precisamente porque
  `verify_email_token_query/2` valida que o email não foi alterado, o que é
  o ponto de partida por esta função.

  O token fornecido é válido se corresponder à sua contraparte com hash no
  banco de dados e se não expirou (após @change_email_validity_in_days).
  O contexto deve sempre começar com "change:".
  """
  def verify_change_email_token_query(token, "change:" <> _ = context) do
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
  Retorna a estrutura de token para o valor e o contexto de token fornecidos.
  """
  def token_and_context_query(token, context) do
    from UserToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Obtém todos os tokens do usuário fornecido para os contextos fornecidos.
  """
  def user_and_contexts_query(user, :all) do
    from t in UserToken, where: t.user_cpf == ^user.cpf
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in UserToken, where: t.user_cpf == ^user.cpf and t.context in ^contexts
  end
end
