defmodule PescarteWeb.GraphQL.Resolver.Login do
  alias Pescarte.Identidades.Handlers.UsuarioHandler

  @token_salt "autenticação de usuário"

  def resolve(%{input: %{cpf: cpf, senha: password}}, _resolution) do
    case UsuarioHandler.fetch_usuario_by_cpf_and_password(cpf, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(PescarteWeb.Endpoint, @token_salt, user.id)
        {:ok, %{usuario: user, token: token}}

      error ->
        error
    end
  end
end
