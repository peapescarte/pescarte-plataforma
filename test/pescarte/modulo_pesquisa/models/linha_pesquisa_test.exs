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

    assert {:ok, linha_pesquisa} = LinhaPesquisa.changeset(attrs)
    assert linha_pesquisa.nucleo_pesquisa_id == nucleo_pesquisa.id
    assert linha_pesquisa.desc_curta == "Desc Curta"
    assert linha_pesquisa.numero == 123
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

    assert {:ok, linha_pesquisa} = LinhaPesquisa.changeset(attrs)
    assert linha_pesquisa.nucleo_pesquisa_id == nucleo_pesquisa.id
    assert linha_pesquisa.desc_curta == "Desc Curta"
    assert linha_pesquisa.numero == 123
    assert linha_pesquisa.desc == "Desc"
    assert linha_pesquisa.responsavel_lp_id == responsavel_lp.id
  end

  test "changeset inválido sem campo obrigatório" do
    attrs = %{
      desc_curta: "Desc Curta",
      numero: 123
    }

    assert {:error, changeset} = LinhaPesquisa.changeset(attrs)
    assert Keyword.get(changeset.errors, :nucleo_pesquisa_id)
  end

  test "changeset inválido com desc_curta longa demais" do
    attrs = %{
      nucleo_pesquisa_id: insert(:nucleo_pesquisa).id,
      desc_curta: "a" |> String.duplicate(91),
      numero: 123
    }

    assert {:error, changeset} = LinhaPesquisa.changeset(attrs)
    assert Keyword.get(changeset.errors, :desc_curta)
  end

  test "changeset inválido com desc longa demais" do
    attrs = %{
      nucleo_pesquisa_id: insert(:nucleo_pesquisa).id,
      desc_curta: "Desc Curta",
      numero: 123,
      desc: "a" |> String.duplicate(281)
    }

    assert {:error, changeset} = LinhaPesquisa.changeset(attrs)
    assert Keyword.get(changeset.errors, :desc)
  end
end
