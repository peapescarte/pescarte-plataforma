defmodule PlataformaDigitalAPI.Resolver.Tag do
  alias ModuloPesquisa.Handlers.MidiasHandler
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.Midia.Categoria

  def create(%{input: args}, _resolution) do
    MidiasHandler.create_tag(args)
  end

  def create_multiple(%{input: args}, _resolution) do
    MidiasHandler.create_multiple_tags(args)
  end

  def list(_args, _resolution) do
    {:ok, MidiasHandler.list_tag()}
  end

  def list_categorias(%Categoria{} = categoria, _args, _resolution) do
    {:ok, MidiasHandler.list_tags_from_categoria(categoria.nome)}
  end

  def list_midias(%Midia{} = midia, _args, _Resolution) do
    {:ok, MidiasHandler.list_tags_from_midia(midia.link)}
  end

  def update(%{input: args}, _resolution) do
    MidiasHandler.update_tag(args)
  end
end
