defmodule PescarteWeb.GraphQL.Resolvers.User do
  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  def list(_args, _resolution) do
    {:ok, Accounts.list_user()}
  end

  def get_by_midia(%Midia{} = midia, _args, _resolution) do
    case Accounts.get_user_by_id(midia.author_id) do
      nil -> {:error, "Usuário não encontrado"}
      user -> {:ok, user}
    end
  end
end
