defmodule PescarteWeb.GraphQL.Resolver.Categoria do
  alias Pescarte.ModuloPesquisa.Handlers.MidiasHandler
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag

  def get(%Tag{} = tag, _args, _resolution) do
    MidiasHandler.fetch_categoria(tag.categoria_id)
  end

  def list(_args, _resolution) do
    {:ok, MidiasHandler.list_categoria()}
  end
end
