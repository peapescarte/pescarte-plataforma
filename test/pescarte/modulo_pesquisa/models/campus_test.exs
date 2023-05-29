defmodule Pescarte.ModuloPesquisa.Models.CampusTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    attrs = %{
      acronimo: "ABC",
      endereco_id: insert(:endereco).id
    }

    changeset = Campus.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :acronimo) == "ABC"
    assert get_change(changeset, :id_publico)
  end

  test "changeset válido com campos opcionais" do
    attrs = %{
      acronimo: "ABC",
      endereco_id: insert(:endereco).id,
      nome: "Campus ABC"
    }

    changeset = Campus.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :acronimo) == "ABC"
    assert get_change(changeset, :nome) == "Campus ABC"
  end

  test "changeset inválido sem campos obrigatórios" do
    attrs = %{}

    changeset = Campus.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :acronimo)
    assert Keyword.get(changeset.errors, :endereco_id)
  end

  test "changeset inválido com acrônimo em caixa baixa" do
    attrs = %{
      acronimo: "abc",
      endereco_id: insert(:endereco).id
    }

    changeset = Campus.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :acronimo)
  end

  test "changeset inválido com endereco_id inválido" do
    attrs = %{
      acronimo: "ABC",
      endereco_id: "invalid_id"
    }

    changeset = Campus.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :endereco_id)
  end
end
