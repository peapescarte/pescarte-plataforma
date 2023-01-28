defmodule Pescarte.Domains.ModuloPesquisa.IO.MidiaRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @required_fields ~w(type filename filedate sensible? link pesquisador_id)a
  @optional_fields ~w(observation alt_text)a

  @impl true
  def all do
    Database.all(Midia)
  end

  def all_by_tag(%Tag{} = tag) do
    [tag] = Database.all(from t in Tag, where: t.id == ^tag.id, preload: :midias)

    tag.midias
  end

  @impl true
  def fetch(id) do
    fetch(Midia, id)
  end

  @impl true
  def fetch_by(params) do
    fetch_by(Midia, params)
  end

  @impl true
  def insert(attrs, tags \\ []) do
    %Midia{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> foreign_key_constraint(:pesquisador_id)
    |> put_assoc(:tags, tags)
    |> Database.insert()
  end

  @impl true
  def update(%Midia{} = midia, attrs) do
    fields = ~w(type link filename filedate observation alt_text)a

    midia
    |> cast(attrs, fields)
    |> unique_constraint(:filename)
    |> unique_constraint(:link)
    |> Database.update()
  end
end
