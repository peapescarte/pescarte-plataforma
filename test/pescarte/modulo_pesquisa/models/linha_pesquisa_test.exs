defmodule Pescarte.ModuloPesquisa.Models.LinhaPesquisaTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    nucleo_pesquisa = insert(:nucleo_pesquisa)

    attrs = %{
      nucleo_pesquisa_id: nucleo_pesquisa.id,
      desc_curta: "Desc Curta",
      numero: 123
    }

    changeset = LinhaPesquisa.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :nucleo_pesquisa_id) == nucleo_pesquisa.id
    assert get_change(changeset, :desc_curta) == "Desc Curta"
    assert get_change(changeset, :numero) == 123
  end

  test "changeset válido com campo adicional" do
    nucleo_pesquisa = insert(:nucleo_pesquisa)
    responsavel_lp = insert(:pesquisador)

    attrs = %{
      nucleo_pesquisa_id: nucleo_pesquisa.id,
      desc_curta: "Desc Curta",
      numero: 123,
      desc: "Desc",
      responsavel_lp_id: responsavel_lp.id
    }

    changeset = LinhaPesquisa.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :nucleo_pesquisa_id) == nucleo_pesquisa.id
    assert get_change(changeset, :desc_curta) == "Desc Curta"
    assert get_change(changeset, :numero) == 123
    assert get_change(changeset, :desc) == "Desc"
    assert get_change(changeset, :responsavel_lp_id) == responsavel_lp.id
  end

  test "changeset inválido sem campo obrigatório" do
    attrs = %{
      desc_curta: "Desc Curta",
      numero: 123
    }

    changeset = LinhaPesquisa.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :nucleo_pesquisa_id)
  end

  test "changeset inválido com desc_curta longa demais" do
    attrs = %{
      nucleo_pesquisa_id: insert(:nucleo_pesquisa).id,
      desc_curta: "a" |> String.duplicate(91),
      numero: 123
    }

    changeset = LinhaPesquisa.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc_curta)
  end

  test "changeset inválido com desc longa demais" do
    attrs = %{
      nucleo_pesquisa_id: insert(:nucleo_pesquisa).id,
      desc_curta: "Desc Curta",
      numero: 123,
      desc: "a" |> String.duplicate(281)
    }

    changeset = LinhaPesquisa.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc)
  end
end
