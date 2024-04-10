defmodule PescarteWeb.GraphQL.Resolver.User do
  alias Pescarte.Identidades.Handlers.UsuarioHandler
  alias Pescarte.ModuloPesquisa.Models.Midia

  def list(_args, _resolution) do
    {:ok, UsuarioHandler.list_usuario()}
  end

  def get_by_midia(%Midia{} = midia, _args, _resolution) do
    case UsuarioHandler.fetch_usuario(midia.autor_id) do
      {:error, :not_found} -> {:error, "Usuário não encontrado"}
      {:ok, user} -> {:ok, user}
    end
  end
end
