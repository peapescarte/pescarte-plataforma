defmodule Pescarte.Domains.ModuloPesquisa.IO.CidadeRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade

  @impl true
  def fetch(id) do
    fetch(Cidade, id)
  end

  @impl true
  def insert(attrs) do
    %Cidade{}
    |> cast(attrs, [:county])
    |> validate_required([:county])
    |> unique_constraint(:county)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end
end
