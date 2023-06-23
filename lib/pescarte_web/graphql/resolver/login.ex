defmodule PescarteWeb.GraphQL.Resolver.Login do
  alias Pescarte.Domains.Accounts

  @token_salt "autenticação de usuário"

  def resolve(%{input: %{cpf: cpf, senha: password}}, _resolution) do
    case Accounts.fetch_user_by_cpf_and_password(cpf, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(PescarteWeb.Endpoint, @token_salt, user.id_publico)
        {:ok, %{usuario: user, token: token}}

      error ->
        error
    end
  end
end
