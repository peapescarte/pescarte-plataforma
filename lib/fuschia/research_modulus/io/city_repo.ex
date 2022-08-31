defmodule Fuschia.ResearchModulus.IO.CityRepo do
  use Fuschia, :repo

  alias Fuschia.ResearchModulus.Models.City

  @impl true
  def fetch(id) do
    fetch(City, id)
  end

  @impl true
  def insert(%City{} = city) do
    city
    |> cast(%{}, [:county])
    |> validate_required([:county])
    |> unique_constraint(:county)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end
end
