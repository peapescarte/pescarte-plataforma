defmodule Pescarte.Cotacoes.Models.PescadoTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Cotacoes.Models.Pescado

  @moduletag :unit

  test "changeset valido com campos obrigatorios" do
    attrs = %{codigo: "COD123"}

    changeset = Pescado.changeset(%Pescado{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :codigo) == "COD123"
  end

  test "changeset valido com campos opcionais" do
    attrs = %{codigo: "COD123", embalagem: "umaembalagem", descricao: "descricao"}

    changeset = Pescado.changeset(%Pescado{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :codigo) == "COD123"
    assert get_change(changeset, :embalagem) == "umaembalagem"
    assert get_change(changeset, :descricao) == "descricao"
  end

  test "changeset invalido sem campos obrigatorios" do
    changeset = Pescado.changeset(%Pescado{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :codigo)
  end
end
