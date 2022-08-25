defmodule Fuschia.ModuloPesquisa.IO.CidadeRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.Cidade

  @impl true
  def fetch(id) do
    fetch(Cidade, id)
  end

  @impl true
  def insert(%Cidade{} = city) do
    city
    |> cast(%{}, [:municipio])
    |> validate_required([:municipio])
    |> unique_constraint(:municipio)
    |> put_change(:id, Nanoid.generate())
    |> Database.insert()
  end
end
