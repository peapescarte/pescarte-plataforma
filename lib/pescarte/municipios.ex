defmodule Pescarte.Municipios do
  @moduledoc """
  Context para gerenciar Municipios e Unidades.
  """

  import Ecto.Query, warn: false
  alias Pescarte.Database.Repo

  alias Pescarte.Municipios.{Municipio, Unit}

  # Funções para Municipios

  def list_municipio do
    Repo.all(Municipio)
  end

  def get_municipio!(id) do
    Repo.get!(Municipio, id) |> Repo.preload(:units)
  end

  def create_municipio(attrs \\ %{}) do
    %Municipio{}
    |> Municipio.changeset(attrs)
    |> Repo.insert()
  end

  def update_municipio(%Municipio{} = municipio, attrs) do
    municipio
    |> Municipio.changeset(attrs)
    |> Repo.update()
  end

  def change_municipio(%Municipio{} = municipio) do
    Municipio.changeset(municipio, %{})
  end

  # Funções para Unidades

  def list_units do
    Repo.all(Unit)
    |> Repo.preload(:municipio)
  end

  def get_unit!(id), do: Repo.get!(Unit, id) |> Repo.preload(:municipio)

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

  def change_unit(%Unit{} = unit) do
    Unit.changeset(unit, %{})
  end
end
