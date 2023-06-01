defmodule Pescarte.ModuloPesquisa.ModuloPesquisaTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa

  @moduletag :unit

  describe "create_campus/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_campus(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:campus)
      assert {:ok, _campus} = ModuloPesquisa.create_campus(attrs)
    end
  end

  describe "create_categoria/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_categoria(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:categoria)
      assert {:ok, _categoria} = ModuloPesquisa.create_categoria(attrs)
    end
  end

  describe "create_linha_pesquisa/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_linha_pesquisa(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:linha_pesquisa)
      assert {:ok, _lp} = ModuloPesquisa.create_linha_pesquisa(attrs)
    end
  end

  describe "create_midia/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_midia(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:midia)
      assert {:ok, _changeset} = ModuloPesquisa.create_midia(attrs)
    end
  end

  describe "create_midia_with_tags/2" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_midia_with_tags(%{}, [])
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:midia)
      tags = insert_list(2, :tag)
      assert {:ok, midia} = ModuloPesquisa.create_midia_with_tags(attrs, tags)
      assert length(midia.tags) == 2
    end
  end

  describe "create_nucleo_pesquisa/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_nucleo_pesquisa(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:nucleo_pesquisa)
      assert {:ok, _} = ModuloPesquisa.create_nucleo_pesquisa(attrs)
    end
  end

  describe "create_pesquisador/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_pesquisador(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:pesquisador)
      assert {:ok, _} = ModuloPesquisa.create_pesquisador(attrs)
    end
  end

  describe "create_relatorio_anual/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_relatorio_anual(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:relatorio_anual)
      assert {:ok, _} = ModuloPesquisa.create_relatorio_anual(attrs)
    end
  end

  describe "create_relatorio_mensal/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_relatorio_mensal(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:relatorio_mensal)
      assert {:ok, _} = ModuloPesquisa.create_relatorio_mensal(attrs)
    end
  end

  describe "create_relatorio_trimestral/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = ModuloPesquisa.create_relatorio_trimestral(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:relatorio_trimestral)
      assert {:ok, _} = ModuloPesquisa.create_relatorio_anual(attrs)
    end
  end

  describe "create_tag/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _} = ModuloPesquisa.create_tag(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:tag)
      assert {:ok, _} = ModuloPesquisa.create_tag(attrs)
    end
  end

  describe "fetch_pesquisador/1" do
    test "quando o id é inválido" do
      assert {:error, :not_found} = ModuloPesquisa.fetch_pesquisador("inválido")
    end

    test "quando o id é válido" do
      pesquisador = insert(:pesquisador)
      assert {:ok, _} = ModuloPesquisa.fetch_pesquisador(pesquisador.id_publico)
    end
  end

  describe "fetch_midia/1" do
    test "quando o id é inválido" do
      assert {:error, :not_found} = ModuloPesquisa.fetch_midia("inválido")
    end

    test "quando o id é válido" do
      midia = insert(:midia)
      assert {:ok, _} = ModuloPesquisa.fetch_midia(midia.id_publico)
    end
  end

  describe "update_midia/2" do
    test "quando os parâmetros são inválidos" do
      midia = insert(:midia)
      assert {:error, _} = ModuloPesquisa.update_midia(midia, %{link: nil})
    end

    test "quando os parâmetros são iguais ao atual" do
      midia = insert(:midia)
      attrs = Map.from_struct(midia)
      assert {:ok, _} = ModuloPesquisa.update_midia(midia, attrs)
    end

    test "quando os parâmetros são válidos" do
      midia = insert(:midia)
      attrs = fixture(:midia)
      assert {:ok, _} = ModuloPesquisa.update_midia(midia, attrs)
    end
  end

  describe "update_midia_with_tags/2" do
    test "quando os parâmetros são inválidos" do
      midia = insert(:midia)
      assert {:error, _} = ModuloPesquisa.update_midia_with_tags(midia, %{link: nil}, [])
    end

    test "quando os parâmetros são iguais ao atual" do
      tags = insert_list(2, :tag)
      midia = insert(:midia, tags: tags)
      attrs = Map.from_struct(midia)
      assert {:error, _} = ModuloPesquisa.update_midia_with_tags(midia, attrs, tags)
    end

    test "quando os parâmetros são válidos" do
      midia = insert(:midia)
      attrs = fixture(:midia)
      tags = insert_list(2, :tag)
      assert {:ok, _} = ModuloPesquisa.update_midia_with_tags(midia, attrs, tags)
    end
  end

  describe "update_pesquisador/2" do
    test "quando os parâmetros são inválidos" do
      pesquisador = insert(:pesquisador)
      assert {:error, _} = ModuloPesquisa.update_pesquisador(pesquisador, %{rg: nil})
    end

    test "quando os parâmetros são iguais ao atual" do
      pesquisador = insert(:pesquisador)
      attrs = Map.from_struct(pesquisador)
      assert {:ok, _} = ModuloPesquisa.update_pesquisador(pesquisador, attrs)
    end

    test "quando os parâmetros são válidos" do
      pesquisador = insert(:pesquisador)
      attrs = fixture(:pesquisador)
      assert {:ok, _} = ModuloPesquisa.update_pesquisador(pesquisador, attrs)
    end
  end

  describe "update_tag/2" do
    test "quando os parâmetros são inválidos" do
      tag = insert(:tag)
      assert {:error, _} = ModuloPesquisa.update_tag(tag, %{etiqueta: nil})
    end

    test "quando os parâmetros são iguais ao atual" do
      tag = insert(:tag)
      attrs = Map.from_struct(tag)
      assert {:ok, _} = ModuloPesquisa.update_tag(tag, attrs)
    end

    test "quando os parâmetros são válidos" do
      tag = insert(:tag)
      attrs = fixture(:tag)
      assert {:ok, _} = ModuloPesquisa.update_tag(tag, attrs)
    end
  end

  describe "list_categoria/0" do
    test "quando não há nenhum registro" do
      categorias = ModuloPesquisa.list_categoria()
      assert length(categorias) == 0
    end

    test "quando há registros" do
      insert_list(3, :categoria)
      categorias = ModuloPesquisa.list_categoria()
      assert length(categorias) == 3
    end
  end

  describe "list_pesquisador/0" do
    test "quando não há nenhum registro" do
      pesquisadores = ModuloPesquisa.list_pesquisador()
      assert length(pesquisadores) == 0
    end

    test "quando há registros" do
      insert_list(2, :pesquisador)
      pesquisadores = ModuloPesquisa.list_pesquisador()
      # orientadores tbm...
      assert length(pesquisadores) == 4
    end
  end

  describe "list_relatorios_pesquisa/0" do
    test "quando não há nenhum registro" do
      relatorios = ModuloPesquisa.list_relatorios_pesquisa()
      assert length(relatorios) == 0
    end

    test "quando há registros" do
      insert(:relatorio_anual)
      insert_list(4, :relatorio_mensal)
      insert_list(2, :relatorio_trimestral)

      relatorios = ModuloPesquisa.list_relatorios_pesquisa()
      assert length(relatorios) == 7
    end
  end

  describe "list_relatorios_pesquisa_from_pesquisador/1" do
    test "quando não há nenhum registro" do
      pesquisador = insert(:pesquisador)
      relatorios = ModuloPesquisa.list_relatorios_pesquisa_from_pesquisador(pesquisador.id)
      assert length(relatorios) == 0
    end

    test "quando há registros" do
      pesquisador = insert(:pesquisador)
      insert(:relatorio_anual, pesquisador_id: pesquisador.id)
      insert_list(4, :relatorio_mensal, pesquisador_id: pesquisador.id)
      insert_list(2, :relatorio_trimestral, pesquisador_id: pesquisador.id)

      relatorios = ModuloPesquisa.list_relatorios_pesquisa_from_pesquisador(pesquisador.id)
      assert length(relatorios) == 7
    end
  end

  describe "list_tags_from_midia/1" do
    test "quando não há nenhum registro" do
      midia = insert(:midia)
      tags = ModuloPesquisa.list_tags_from_midia(midia.id_publico)
      assert length(tags) == 0
    end

    test "quando há registros" do
      tags = insert_list(4, :tag)
      midia = insert(:midia, tags: tags)
      tags = ModuloPesquisa.list_tags_from_midia(midia.id_publico)
      assert length(tags) == 4
    end
  end
end
