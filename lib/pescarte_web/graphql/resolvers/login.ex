defmodule PescarteWeb.GraphQL.Resolvers.Login do
  alias Pescarte.Domains.Accounts

  def resolve(%{cpf: cpf, password: password}, _resolution) do
    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(PescarteWeb.Endpoint, "user auth", user.id)

        {:ok, %{user: Map.drop(user, [:id]), token: token}}

      {:error, :not_found} ->
        {:error, "Usuário não encontrado"}
    end
  end
end
