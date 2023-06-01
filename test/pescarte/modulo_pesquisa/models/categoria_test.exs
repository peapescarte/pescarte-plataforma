defmodule Pescarte.ModuloPesquisa.Models.CategoriaTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{nome: "Categoria Teste"}

    assert {:ok, categoria} = Categoria.changeset(attrs)
    assert categoria.nome == "Categoria Teste"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    assert {:error, changeset} = Categoria.changeset(%{})
    assert Keyword.get(changeset.errors, :nome)
  end
end
