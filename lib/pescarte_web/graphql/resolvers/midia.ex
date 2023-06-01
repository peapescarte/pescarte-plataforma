defmodule PescarteWeb.GraphQL.Resolvers.Midia do
  alias Pescarte.Domains.ModuloPesquisa.Handlers
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def create(%{input: args}, _resolution) do
    Handlers.Midias.create_midia(args)
  end

  def get(%{id: midia_id}, _resolution) do
    Handlers.Midias.fetch_midia(midia_id)
  end

  def list(_args, _resolution) do
    {:ok, Handlers.Midias.list_midia()}
  end

  def list_tags(%Tag{} = tag, _args, _resolution) do
    {:ok, Handlers.Midias.list_midias_from_tag(tag.id)}
  end

  def remove_tags(args, _resolution) do
    Handlers.Midias.remove_tags_from_midia(args.midia_id, args.tags)
  end

  def update(%{input: args}, _resolution) do
    Handlers.Midias.update_midia(args.id, args.tags)
  end
end
