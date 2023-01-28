defmodule Pescarte.Domains.ModuloPesquisa.IO.CategoriaRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  @required_fields ~w(name)a

  @impl true
  def all do
    Database.all(Categoria)
  end

  @impl true
  def fetch(id) do
    fetch(Categoria, id)
  end

  @impl true
  def fetch_by(params) do
    fetch_by(Categoria, params)
  end

  @impl true
  def insert(attrs) do
    %Categoria{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end
end
