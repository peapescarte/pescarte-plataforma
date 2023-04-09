defmodule PescarteWeb.GraphQL.Resolvers.Categoria do
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def get(%Tag{} = tag, _args, _resolution) do
    case ModuloPesquisa.get_categoria(id: tag.categoria_id) do
      nil -> {:error, "Categoria não encontrada"}
      categoria -> {:ok, categoria}
    end
  end

  def list(_args, _resolution) do
    {:ok, ModuloPesquisa.list_categorias()}
  end
end
