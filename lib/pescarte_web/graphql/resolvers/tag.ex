defmodule PescarteWeb.GraphQL.Resolvers.Tag do
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def list_categorias(%Categoria{} = categoria, _args, _resolution) do
    {:ok, ModuloPesquisa.list_tags_by(categoria)}
  end

  def list_midias(%Midia{} = midia, _args, _Resolution) do
    {:ok, ModuloPesquisa.list_tags_by(midia)}
  end

  def create_tag(args, _resolution) do
    ModuloPesquisa.create_tag(args)
  end
end
