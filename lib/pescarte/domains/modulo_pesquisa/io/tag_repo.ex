defmodule Pescarte.Domains.ModuloPesquisa.IO.TagRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @required_fields ~w(label categoria_id)a

  @impl true
  def all do
    Database.all(Tag)
  end

  def all_by_midia(%Midia{} = midia) do
    [midia] = Database.all(from m in Midia, where: m.id == ^midia.id, preload: :tags)

    midia.tags
  end

  def all_by_categoria(%Categoria{} = categoria) do
    query = from t in Tag, where: t.categoria_id == ^categoria.id

    Database.all(query)
  end

  @impl true
  def fetch(id) do
    fetch(Tag, id)
  end

  @impl true
  def fetch_by(params) do
    fetch_by(Tag, params)
  end

  @impl true
  def insert(attrs) do
    %Tag{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:label)
    |> foreign_key_constraint(:categoria_id)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end
end
