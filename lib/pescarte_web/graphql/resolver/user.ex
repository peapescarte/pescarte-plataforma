defmodule PescarteWeb.GraphQL.Resolver.User do
  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  def list(_args, _resolution) do
    {:ok, Accounts.list_user()}
  end

  def get_by_midia(%Midia{} = midia, _args, _resolution) do
    case Accounts.fetch_user(midia.autor_id) do
      {:error, :not_found} -> {:error, "Usuário não encontrado"}
      {:ok, user} -> {:ok, user}
    end
  end
end
