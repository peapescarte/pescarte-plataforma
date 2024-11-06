defmodule Pescarte.Regions do
  @moduledoc """
  Context para gerenciar Regiões e Unidades.
  """

  import Ecto.Query, warn: false
  alias Pescarte.Database.Repo

  alias Pescarte.Regions.{Region, Unit}

  # Funções para Regiões

  def list_regions do
    Repo.all(Region)
  end

  def get_region!(id), do: Repo.get!(Region, id)

  def create_region(attrs \\ %{}) do
    %Region{}
    |> Region.changeset(attrs)
    |> Repo.insert()
  end

  def update_region(%Region{} = region, attrs) do
    region
    |> Region.changeset(attrs)
    |> Repo.update()
  end

  def delete_region(%Region{} = region) do
    Repo.delete(region)
  end

  def change_region(%Region{} = region) do
    Region.changeset(region, %{})
  end

  # Funções para Unidades

  def list_units do
    Repo.all(Unit)
    |> Repo.preload(:region)
  end

  def get_unit!(id), do: Repo.get!(Unit, id) |> Repo.preload(:region)

  def create_unit(attrs \\ %{}) do
    %Unit{}
    |> Unit.changeset(attrs)
    |> Repo.insert()
  end

  def update_unit(%Unit{} = unit, attrs) do
    unit
    |> Unit.changeset(attrs)
    |> Repo.update()
  end

  def delete_unit(%Unit{} = unit) do
    Repo.delete(unit)
  end

  def change_unit(%Unit{} = unit) do
    Unit.changeset(unit, %{})
  end
end
