defmodule Backend.ResearchModulus.IO.MidiaRepo do
  use Backend, :repo

  alias Backend.ResearchModulus.Models.Midia

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
  def insert(attrs) do
    %Midia{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> foreign_key_constraint(:researcher_id)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  @impl true
  def update(%Midia{} = midia, attrs) do
    fields = ~w(type link)a

    midia
    |> cast(attrs, fields)
    |> unique_constraint(:link)
    |> Database.update()
  end
end
