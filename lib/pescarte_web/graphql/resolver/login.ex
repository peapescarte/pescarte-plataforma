defmodule PescarteWeb.GraphQL.Resolver.Login do
  alias Pescarte.Identidades.Models.Usuario

  @token_salt "autenticação de usuário"

  def resolve(%{input: %{cpf: cpf, senha: password}}, _resolution) do
    case Usuario.fetch_by(cpf: cpf, password: password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(PescarteWeb.Endpoint, @token_salt, user.id)
        {:ok, %{usuario: user, token: token}}

      error ->
        error
    end
  end
end
