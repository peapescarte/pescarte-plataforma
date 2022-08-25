defmodule Fuschia.ModuloPesquisa.IO.NucleoRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.Nucleo

  @impl true
  def all do
    Database.all(Nucleo)
  end

  @impl true
  def fetch(id) do
    fetch(Nucleo, id)
  end

  @impl true
  def insert(%Nucleo{} = core) do
    core
    |> cast(%{}, [:nome, :desc])
    |> validate_required([:nome, :desc])
    |> validate_length(:desc, max: 400)
    |> put_change(:id, Nanoid.generate())
    |> Database.insert()
  end

  @impl true
  def update(%Nucleo{} = core) do
    values = Map.take(core, [:desc])

    %Nucleo{id: core.id}
    |> cast(values, [:desc])
    |> validate_required([:desc])
    |> Database.update()
  end
end
