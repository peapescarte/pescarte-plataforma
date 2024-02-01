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
      cotacao_link: cotacao.link,
      cotacao_data: cotacao.data,
      fonte_nome: fonte.nome,
      pescado_codigo: pescado.codigo,
      preco_minimo: 1000,
      preco_maximo: 2000
    }

    changeset = CotacaoPescado.changeset(%CotacaoPescado{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :cotacao_link) == cotacao.link
    assert get_change(changeset, :cotacao_data) == cotacao.data
    assert get_change(changeset, :fonte_nome) == fonte.nome
    assert get_change(changeset, :pescado_codigo) == pescado.codigo
    assert get_change(changeset, :preco_minimo) == 1000
    assert get_change(changeset, :preco_maximo) == 2000
  end

  test "changeset valido com campos opcionais" do
    cotacao = insert(:cotacao)
    fonte = insert(:fonte)
    pescado = insert(:pescado)

    attrs = %{
      cotacao_link: cotacao.link,
      cotacao_data: cotacao.data,
      fonte_nome: fonte.nome,
      pescado_codigo: pescado.codigo,
      preco_minimo: 1000,
      preco_maximo: 2000,
      preco_medio: 1500,
      preco_mais_comum: 1750
    }

    changeset = CotacaoPescado.changeset(%CotacaoPescado{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :cotacao_link) == cotacao.link
    assert get_change(changeset, :cotacao_data) == cotacao.data
    assert get_change(changeset, :fonte_nome) == fonte.nome
    assert get_change(changeset, :pescado_codigo) == pescado.codigo
    assert get_change(changeset, :preco_minimo) == 1000
    assert get_change(changeset, :preco_maximo) == 2000
    assert get_change(changeset, :preco_medio) == 1500
    assert get_change(changeset, :preco_mais_comum) == 1750
  end

  test "changeset invalido sem campos obrigatorios" do
    changeset = CotacaoPescado.changeset(%CotacaoPescado{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cotacao_link)
    assert Keyword.get(changeset.errors, :fonte_nome)
    assert Keyword.get(changeset.errors, :pescado_codigo)
    assert Keyword.get(changeset.errors, :preco_maximo)
    assert Keyword.get(changeset.errors, :preco_minimo)
  end
end
