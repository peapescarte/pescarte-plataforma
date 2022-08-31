defmodule Fuschia.ResearchModulus.IO.MidiaRepo do
  use Fuschia, :repo

  alias Fuschia.ResearchModulus.Models.Midia

  @required_fields ~w(type link researcher_id)a

  @impl true
  def all do
    Database.all(Midia)
  end

  @impl true
  def fetch(id) do
    fetch(Midia, id)
  end

  @impl true
  def insert(%Midia{} = midia) do
    midia
    |> cast(%{}, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> foreign_key_constraint(:researcher_id)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  @impl true
  def update(%Midia{} = midia) do
    fields = ~w(type link)a
    values = Map.take(midia, fields)

    %Midia{id: midia.id}
    |> cast(values, fields)
    |> unique_constraint(:link)
    |> Database.update()
  end
end
