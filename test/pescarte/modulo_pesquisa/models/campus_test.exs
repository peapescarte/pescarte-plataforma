defmodule Pescarte.ModuloPesquisa.Models.CampusTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    endereco = insert(:endereco)

    attrs = %{
      acronimo: "ABC",
      endereco_id: endereco.id
    }

    assert {:ok, campus} = Campus.changeset(attrs)
    assert campus.acronimo == "ABC"
    assert campus.endereco_id == endereco.id
    assert campus.id_publico
  end

  test "changeset válido com campos opcionais" do
    attrs = %{
      acronimo: "ABC",
      endereco_id: insert(:endereco).id,
      nome: "Campus ABC",
      nome_universidade: "Um Exemplo de Nome"
    }

    assert {:ok, campus} = Campus.changeset(attrs)
    assert campus.acronimo == "ABC"
    assert campus.nome == "Campus ABC"
    assert campus.nome_universidade == "Um Exemplo de Nome"
  end

  test "changeset inválido sem campos obrigatórios" do
    attrs = %{}

    assert {:error, changeset} = Campus.changeset(attrs)
    assert Keyword.get(changeset.errors, :acronimo)
    assert Keyword.get(changeset.errors, :endereco_id)
  end

  test "changeset inválido com endereco_id inválido" do
    attrs = %{
      acronimo: "ABC",
      endereco_id: "invalid_id"
    }

    assert {:error, changeset} = Campus.changeset(attrs)
    assert Keyword.get(changeset.errors, :endereco_id)
  end
end
