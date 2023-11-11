defmodule Pescarte.ModuloPesquisa.Models.CategoriaTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{nome: "Categoria Teste"}

    changeset = Categoria.changeset(%Categoria{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome) == "Categoria Teste"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    changeset = Categoria.changeset(%Categoria{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :nome)
  end
end
