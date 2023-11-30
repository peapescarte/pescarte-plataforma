defmodule Cotacoes.Models.FonteTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Cotacoes.Models.Fonte

  @moduletag :unit

  test "changeset valido com campos obrigatorios" do
    attrs = %{nome: "nome", link: "https://example.com"}

    changeset = Fonte.changeset(%Fonte{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome) == "nome"
    assert get_change(changeset, :link) == "https://example.com"
  end

  test "changeset valido com campos opcionais" do
    attrs = %{nome: "nome", link: "https://example.com", descricao: "descricao"}

    changeset = Fonte.changeset(%Fonte{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome) == "nome"
    assert get_change(changeset, :link) == "https://example.com"
    assert get_change(changeset, :descricao) == "descricao"
  end

  test "changeset invalido sem campos obrigatorios" do
    changeset = Fonte.changeset(%Fonte{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :nome)
    assert Keyword.get(changeset.errors, :link)
  end
end
