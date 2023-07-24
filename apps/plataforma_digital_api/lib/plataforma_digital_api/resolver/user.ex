defmodule PlataformaDigitalAPI.Resolver.User do
  alias Identidades.Handlers.UsuarioHandler
  alias ModuloPesquisa.Models.Midia

  def list(_args, _resolution) do
    {:ok, UsuarioHandler.list_usuario()}
  end

  def get_by_midia(%Midia{} = midia, _args, _resolution) do
    case UsuarioHandler.fetch_usuario_by_id_publico(midia.autor_id) do
      {:error, :not_found} -> {:error, "Usuário não encontrado"}
      {:ok, user} -> {:ok, user}
    end
  end
end
