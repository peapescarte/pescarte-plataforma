defmodule Fuschia.ResearchModulus.IO.CampusRepo do
  use Fuschia, :repo

  alias Fuschia.ResearchModulus.Models.Campus

  @required_fields ~w(initials city_id)a
  @optional_fields ~w(name)a

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
    |> unique_constraint(:name)
    |> unique_constraint(:initials)
    |> foreign_key_constraint(:city_id)
    |> put_change(:public_id, Nanoid.generate())
  end

  def list_campus_by_county(county) do
    query = from c in Campus, where: c.county == ^county

    Database.all(query)
  end
end
