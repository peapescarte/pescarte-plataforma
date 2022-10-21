defmodule Backend.ResearchModulus.IO.ResearchCoreRepo do
  use Backend, :repo

  alias Backend.ResearchModulus.Models.ResearchCore

  @impl true
  def all do
    Database.all(ResearchCore)
  end

  @impl true
  def fetch(id) do
    fetch(ResearchCore, id)
  end

  @impl true
  def insert(attrs) do
    %ResearchCore{}
    |> cast(attrs, [:name, :desc])
    |> validate_required([:name, :desc])
    |> validate_length(:desc, max: 400)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  @impl true
  def update(%ResearchCore{} = core, attrs) do
    core
    |> cast(attrs, [:desc])
    |> validate_required([:desc])
    |> Database.update()
  end
end
