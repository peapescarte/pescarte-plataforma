defmodule Pescarte.ResearchModulus.IO.CampusRepo do
  use Pescarte, :repo

  alias Pescarte.ResearchModulus.Models.Campus

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
  def insert(attrs) do
    %Campus{}
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> unique_constraint(:initials)
    |> foreign_key_constraint(:city_id)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  def list_campus_by_county(county) do
    query = from c in Campus, where: c.county == ^county

    Database.all(query)
  end
end
