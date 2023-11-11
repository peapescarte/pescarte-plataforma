defmodule Pescarte.ModuloPesquisa.Models.CampusTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Identidades.Factory
  alias Pescarte.ModuloPesquisa.Models.Campus

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    endereco = Factory.insert(:endereco)

    attrs = %{
      acronimo: "ABC",
      endereco_cep: endereco.cep
    }

    changeset = Campus.changeset(%Campus{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :acronimo) == "ABC"
    assert get_change(changeset, :endereco_cep) == endereco.cep
  end

  test "changeset válido com campos opcionais" do
    attrs = %{
      acronimo: "ABC",
      endereco_cep: Factory.insert(:endereco).cep,
      nome: "Campus ABC",
      nome_universidade: "Um Exemplo de Nome"
    }

    changeset = Campus.changeset(%Campus{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :acronimo) == "ABC"
    assert get_change(changeset, :nome) == "Campus ABC"
    assert get_change(changeset, :nome_universidade) == "Um Exemplo de Nome"
  end

  test "changeset inválido sem campos obrigatórios" do
    attrs = %{}

    changeset = Campus.changeset(%Campus{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :acronimo)
    assert Keyword.get(changeset.errors, :endereco_cep)
  end
end
