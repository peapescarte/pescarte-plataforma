defmodule Fuschia.ModuloPesquisa.IO.MidiaRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.Midia

  @required_fields ~w(tipo link tags pesquisador_id)a

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
    |> foreign_key_constraint(:pesquisador_cpf)
    |> put_change(:id, Nanoid.generate())
    |> Database.insert()
  end

  @impl true
  def update(%Midia{} = midia) do
    fields = ~w(tipo link tags)a
    values = Map.take(midia, fields)

    %Midia{id: midia.id}
    |> cast(values, fields)
    |> unique_constraint(:link)
    |> Database.update()
  end
end
