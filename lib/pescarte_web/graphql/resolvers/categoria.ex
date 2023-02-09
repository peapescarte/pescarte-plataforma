defmodule PescarteWeb.GraphQL.Resolvers.Categoria do
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def get(%Tag{} = tag, _args, _resolution) do
    case ModuloPesquisa.get_categoria(id: tag.categoria_id) do
     {:ok, categoria} -> {:ok, categoria}
      {:error, :not_found} -> {:error, "Categoria não encontrada"}
    end
  end

  def list(_args, _resolution) do
    {:ok, ModuloPesquisa.list_categorias()}
  end

  def create_categoria(args, _resolution) do
    ModuloPesquisa.create_categoria(args)
  end
end
