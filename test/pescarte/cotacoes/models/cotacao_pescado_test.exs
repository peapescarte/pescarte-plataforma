defmodule Cotacoes.Models.CotacaoPescadoTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.Cotacoes.Models.CotacaoPescado

  @moduletag :unit

  test "changeset valido com campos obrigatorios" do
    cotacao = insert(:cotacao)
    fonte = insert(:fonte)
    pescado = insert(:pescado)

    attrs = %{
      cotacao_id: cotacao.id,
      fonte_id: fonte.id,
      pescado_id: pescado.id,
      preco_minimo: 1000,
      preco_maximo: 2000
    }

    changeset = CotacaoPescado.changeset(%CotacaoPescado{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :cotacao_id) == cotacao.id
    assert get_change(changeset, :fonte_id) == fonte.id
    assert get_change(changeset, :pescado_id) == pescado.id
    assert get_change(changeset, :preco_minimo) == 1000
    assert get_change(changeset, :preco_maximo) == 2000
  end

  test "changeset valido com campos opcionais" do
    cotacao = insert(:cotacao)
    fonte = insert(:fonte)
    pescado = insert(:pescado)

    attrs = %{
      cotacao_id: cotacao.id,
      fonte_id: fonte.id,
      pescado_id: pescado.id,
      preco_minimo: 1000,
      preco_maximo: 2000,
      preco_medio: 1500,
      preco_mais_comum: 1750
    }

    changeset = CotacaoPescado.changeset(%CotacaoPescado{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :cotacao_id) == cotacao.id
    assert get_change(changeset, :fonte_id) == fonte.id
    assert get_change(changeset, :pescado_id) == pescado.id
    assert get_change(changeset, :preco_minimo) == 1000
    assert get_change(changeset, :preco_maximo) == 2000
    assert get_change(changeset, :preco_medio) == 1500
    assert get_change(changeset, :preco_mais_comum) == 1750
  end

  test "changeset invalido sem campos obrigatorios" do
    changeset = CotacaoPescado.changeset(%CotacaoPescado{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cotacao_id)
    assert Keyword.get(changeset.errors, :fonte_id)
    assert Keyword.get(changeset.errors, :pescado_id)
    assert Keyword.get(changeset.errors, :preco_maximo)
    assert Keyword.get(changeset.errors, :preco_minimo)
  end
end
