defmodule Pescarte.Domains.ModuloPesquisa.IO.PesquisadorRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @required_fields ~w(minibio bolsa link_lattes campus_id user_id)a

  @optional_fields ~w(orientador_id)a

  @update_fields ~w(minibio bolsa link_lattes)a

  def changeset(%Pesquisador{} = pesquisador, attrs \\ %{}) do
    pesquisador
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibio, max: 280)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:orientador_id)
    |> foreign_key_constraint(:campus_id)
    |> put_change(:public_id, Nanoid.generate())
  end

  @impl true
  def all do
    Pesquisador
    |> Database.all()
    |> Database.preload(user: [:contato])
  end

  @impl true
  def fetch(id) do
    fetch(Pesquisador, id)
  end

  @impl true
  def fetch_by(params) do
    fetch_by(Pesquisador, params)
  end

  @impl true
  def insert(attrs) do
    %Pesquisador{}
    |> changeset(attrs)
    |> Database.insert()
  end

  @impl true
  def update(%Pesquisador{} = pesquisador, attrs) do
    pesquisador
    |> cast(attrs, @update_fields)
    |> validate_length(:minibio, max: 280)
    |> Database.update()
  end
end
