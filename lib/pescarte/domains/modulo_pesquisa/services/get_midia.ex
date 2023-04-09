defmodule Pescarte.Domains.ModuloPesquisa.Services.GetMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def process do
    Database.all(Midia)
  end

  @impl true
  def process(id: id) do
    Database.get(Midia, id)
  end

  def process(%Tag{} = tag) do
    tag
    |> Tag.list_midias_query()
    |> Database.all()
    |> hd()
    |> Map.get(:midias)
  end

  def process(params) do
    Database.get_by(Midia, params)
  end
end
