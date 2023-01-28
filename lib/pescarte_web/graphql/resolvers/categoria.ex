defmodule PescarteWeb.GraphQL.Resolvers.Categoria do
  alias Pescarte.Domains.ModuloPesquisa

  def list(_args, _resolution) do
    {:ok, ModuloPesquisa.list_categorias()}
  end

  def create_categoria(args, _resolution) do
    ModuloPesquisa.create_categoria(args)
  end
end
