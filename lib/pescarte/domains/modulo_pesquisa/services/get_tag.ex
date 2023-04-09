defmodule Pescarte.Domains.ModuloPesquisa.Services.GetTag do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def process do
    Database.all(Tag)
  end

  @impl true
  def process([]) do
    process()
  end

  def process(%Midia{} = midia) do
    midia
    |> Midia.list_tags_query()
    |> Database.all()
    |> hd()
    |> Map.get(:tags)
  end

  def process(%Categoria{} = categoria) do
    categoria
    |> Categoria.list_tags_query()
    |> Database.all()
  end

  def process(params) do
    cond do
      Enum.all?(params, &is_tuple/1) ->
        Database.get_by(Tag, params)

      Enum.all?(params, &is_number/1) ->
        params
        |> Tag.list_by_query()
        |> Database.all()

      true ->
        {:error, :invalid_params}
    end
  end
end
