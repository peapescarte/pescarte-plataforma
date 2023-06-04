defmodule PescarteWeb.GraphQL.Resolvers.Categoria do
  alias Pescarte.Domains.ModuloPesquisa.Handlers
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def get(%Tag{} = tag, _args, _resolution) do
    Handlers.Midias.fetch_categoria(tag.categoria_id)
  end

  def list(_args, _resolution) do
    {:ok, Handlers.Midias.list_categoria()}
  end
end
