defmodule PescarteWeb.GraphQL.Resolver.Midia do
  alias Pescarte.ModuloPesquisa.Handlers.MidiasHandler
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag

  def adiciona_tags(%{input: args}, _resolution) do
    MidiasHandler.add_tags_to_midia(args.midia_id, args.tags_id)
  end

  def create(%{input: %{tags: tags} = args}, _resolution) do
    MidiasHandler.create_midia_and_tags(args, tags)
  end

  def create(%{input: args}, _resolution) do
    MidiasHandler.create_midia(args)
  end

  def get(%{id: midia_id}, _resolution) do
    MidiasHandler.fetch_midia(midia_id)
  end

  def list(_args, _resolution) do
    {:ok, MidiasHandler.list_midia()}
  end

  def list_tags(%Tag{} = tag, _args, _resolution) do
    {:ok, MidiasHandler.list_midias_from_tag(tag.etiqueta)}
  end

  def remove_tags(%{input: args}, _resolution) do
    MidiasHandler.remove_tags_from_midia(args.midia_id, args.tags_id)
  end

  def update(%{input: args}, _resolution) do
    MidiasHandler.update_midia(args)
  end
end
