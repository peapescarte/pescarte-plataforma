defmodule Fuschia.ModuloPesquisa.IO.LinhaPesquisaRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa

  @required_fields ~w(nucleo_id descricao_curta numero)a
  @optional_fields ~w(descricao_longa)a

  @impl true
  def all do
    Database.all(LinhaPesquisa)
  end

  @impl true
  def fetch(id) do
    fetch(LinhaPesquisa, id)
  end

  @impl true
  def insert(%LinhaPesquisa{} = line) do
    line
    |> cast(%{}, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:descricao_curta, max: 50)
    |> validate_length(:descricao_longa, max: 280)
    |> foreign_key_constraint(:nucleo_id)
    |> put_change(:id, Nanoid.generate())
    |> Database.insert()
  end

  def list_linha_pesquisa_by_nucleo(core_id) do
    query =
      from l in LinhaPesquisa,
        inner_join: n in assoc(l, :nucleo),
        where: n.id == ^core_id

    Database.all(query)
  end
end
