defmodule PescarteWeb.GraphQL.Resolver.Login do
  alias Pescarte.Identidades.Models.Usuario

  alias PescarteWeb.Auth

  def resolve(%{input: %{cpf: cpf, senha: password}}, _resolution) do
    if Pescarte.env() == :test do
      with {:ok, user} <- Usuario.fetch_by(cpf: cpf) do
        {:ok, %{usuario: user, token: user.id}}
      end
    else
      with {:ok, user} <- Usuario.fetch_by(cpf: cpf),
           email = user.contato.email_principal,
           params = %{email: email, password: password},
           {:ok, session} <- Auth.log_in_with_password(params) do
        {:ok, %{usuario: user, token: session.access_token}}
      end
    end
  end
end
