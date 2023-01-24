defmodule Pescarte.Domains.ModuloPesquisa.IO.NucleoPesquisaRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa

  @impl true
  def all do
    Database.all(NucleoPesquisa)
  end

  @impl true
  def fetch(id) do
    fetch(NucleoPesquisa, id)
  end

  @impl true
  def insert(attrs) do
    %NucleoPesquisa{}
    |> cast(attrs, [:name, :desc])
    |> validate_required([:name, :desc])
    |> validate_length(:desc, max: 400)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  @impl true
  def update(%NucleoPesquisa{} = nucleo_pesquisa, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:desc])
    |> validate_required([:desc])
    |> Database.update()
  end
end
