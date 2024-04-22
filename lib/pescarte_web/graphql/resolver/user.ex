defmodule PescarteWeb.GraphQL.Resolver.User do
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Midia

  def list(_args, _resolution) do
    {:ok, Usuario.all()}
  end

  def get_by_midia(%Midia{} = midia, _args, _resolution) do
    case Usuario.fetch_by(id: midia.autor_id) do
      {:error, :not_found} -> {:error, "Usuário não encontrado"}
      {:ok, user} -> {:ok, user}
    end
  end
end
