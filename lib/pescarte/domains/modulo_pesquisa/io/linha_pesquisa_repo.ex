defmodule Pescarte.Domains.ModuloPesquisa.IO.LinhaPesquisaRepo do
  use Pescarte, :repo

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  @required_fields ~w(nucleo_pesquisa_id sort_desc number)a
  @optional_fields ~w(desc)a

  @impl true
  def all do
    Database.all(LinhaPesquisa)
  end

  @impl true
  def fetch(id) do
    fetch(LinhaPesquisa, id)
  end

  @impl true
  def insert(attrs) do
    %LinhaPesquisa{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:short_desc, max: 90)
    |> validate_length(:desc, max: 280)
    |> foreign_key_constraint(:nucleo_pesquisa_id)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  def list_linha_pesquisa_by_nucleo_pesquisa(nucleo_pesquisa_id) do
    query =
      from(l in LinhaPesquisa,
        inner_join: n in assoc(l, :nucleo_pesquisa),
        where: n.id == ^nucleo_pesquisa_id
      )

    Database.all(query)
  end
end
