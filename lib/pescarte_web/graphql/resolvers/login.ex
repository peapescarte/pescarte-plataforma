defmodule PescarteWeb.GraphQL.Resolvers.Login do
  import AbsintheErrorPayload.Payload

  alias AbsintheErrorPayload.ValidationMessage
  alias Pescarte.Domains.Accounts

  @token_salt "autenticação de usuário"
  @error_message "Usuário não encontrado"

  def resolve(%{input: %{cpf: cpf, senha: password}}, _resolution) do
    case Accounts.fetch_user_by_cpf_and_password(cpf, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(PescarteWeb.Endpoint, @token_salt, user.id)
        payload = %{usuario: Map.drop(user, [:id]), token: token}

        {:ok, success_payload(payload)}

      {:error, :not_found} ->
        {:ok, error_payload(%ValidationMessage{code: 404, message: @error_message})}
    end
  end
end
