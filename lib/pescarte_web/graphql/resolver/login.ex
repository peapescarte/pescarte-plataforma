defmodule PescarteWeb.GraphQL.Resolver.Login do
  alias Pescarte.Domains.Accounts

  @token_salt "autenticação de usuário"
  @error_message "Usuário não encontrado"

  def resolve(%{input: %{cpf: cpf, senha: password}}, _resolution) do
    case Accounts.fetch_user_by_cpf_and_password(cpf, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(PescarteWeb.Endpoint, @token_salt, user.id)
        payload = %{usuario: Map.drop(user, [:id]), token: token}

        {:ok, payload}

      error ->
        error
    end
  end
end
