defmodule PlataformaDigitalAPI.Resolver.Categoria do
  alias ModuloPesquisa.Handlers.MidiasHandler
  alias ModuloPesquisa.Models.Midia.Tag

  def get(%Tag{} = tag, _args, _resolution) do
    MidiasHandler.fetch_categoria(tag.categoria_nome)
  end

  def list(_args, _resolution) do
    {:ok, MidiasHandler.list_categoria()}
  end
end
