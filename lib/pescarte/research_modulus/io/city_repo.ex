defmodule Backend.ResearchModulus.IO.CityRepo do
  use Backend, :repo

  alias Backend.ResearchModulus.Models.City

  @impl true
  def fetch(id) do
    fetch(City, id)
  end

  @impl true
  def insert(attrs) do
    %City{}
    |> cast(attrs, [:county])
    |> validate_required([:county])
    |> unique_constraint(:county)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end
end
