defmodule PescarteWeb.GraphQL.Resolvers.Tag do
  alias Pescarte.Domains.ModuloPesquisa.Handlers
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def create(%{input: args}, _resolution) do
    Handlers.Midias.create_tag(args)
  end

  def create_multiple(%{input: args}, _resolution) do
    Handlers.Midias.create_multiple_tags(args)
  end

  def list(_args, _resolution) do
    {:ok, Handlers.Midias.list_tag()}
  end

  def list_categorias(%Categoria{} = categoria, _args, _resolution) do
    {:ok, Handlers.Midias.list_tags_from_categoria(categoria.id_publico)}
  end

  def list_midias(%Midia{} = midia, _args, _Resolution) do
    {:ok, Handlers.Midias.list_tags_from_midia(midia.id_publico)}
  end

  def update(%{input: args}, _resolution) do
    Handlers.Midias.update_tag(args)
  end
end
