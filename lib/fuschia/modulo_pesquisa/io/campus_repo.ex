defmodule Fuschia.ModuloPesquisa.IO.CampusRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.Campus

  @required_fields ~w(sigla cidade_id)a
  @optional_fields ~w(nome)a

  @impl true
  def all do
    Database.all(Campus)
  end

  @impl true
  def fetch(id) do
    fetch(Campus, id)
  end

  @impl true
  def insert(%Campus{} = campus) do
    campus
    |> cast(%{}, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> unique_constraint(:sigla)
    |> foreign_key_constraint(:cidade_id)
    |> put_change(:id, Nanoid.generate())
  end

  def list_campus_by_municipio(id) do
    query =
      from c in Campus,
        inner_join: m in assoc(c, :municipio),
        where: m.id == ^id

    Database.all(query)
  end
end
