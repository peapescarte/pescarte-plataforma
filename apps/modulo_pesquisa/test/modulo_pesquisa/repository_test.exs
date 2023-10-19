defmodule Pescarte.ModuloPesquisa.RepositoryTest do
  use Database.DataCase, async: true

  import ModuloPesquisa.Factory

  alias ModuloPesquisa.Repository

  @moduletag :unit

  describe "upsert_campus/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_campus(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:campus)
      assert {:ok, _campus} = Repository.upsert_campus(attrs)
    end
  end

  describe "upsert_categoria/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_categoria(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:categoria)
      assert {:ok, _categoria} = Repository.upsert_categoria(attrs)
    end
  end

  describe "upsert_linha_pesquisa/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_linha_pesquisa(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:linha_pesquisa)
      assert {:ok, _lp} = Repository.upsert_linha_pesquisa(attrs)
    end
  end

  describe "upsert_midia/1" do
    test "não cria quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_midia(%{})
    end

    test "cria quando os parâmetros são válidos" do
      attrs = fixture(:midia)
      assert {:ok, _changeset} = Repository.upsert_midia(attrs)
    end

    test "não cria quando os parâmetros são inválidos, com tags" do
      assert {:error, _changeset} = Repository.upsert_midia(%{tags: []})
    end

    test "cria quando os parâmetros são válidos, com tags" do
      attrs = fixture(:midia)
      tags = insert_list(2, :tag)

      assert {:ok, midia} =
               attrs
               |> Map.put(:tags, tags)
               |> Repository.upsert_midia()

      assert length(midia.tags) == 2
    end

    test "não atualiza quando os parâmetros são inválidos" do
      midia = insert(:midia)
      assert {:error, _} = Repository.upsert_midia(midia, %{link: nil})
    end

    test "não modifica quando os parâmetros são iguais ao atual" do
      midia = insert(:midia)
      attrs = Map.from_struct(midia)
      assert {:ok, _} = Repository.upsert_midia(midia, attrs)
    end

    test "atualiza quando os parâmetros são válidos" do
      midia = insert(:midia)
      attrs = fixture(:midia)
      assert {:ok, _} = Repository.upsert_midia(midia, attrs)
    end

    test "não atualiza quando os parâmetros são inválidos, com tags" do
      midia = insert(:midia)
      assert {:error, _} = Repository.upsert_midia(midia, %{link: nil, tags: []})
    end

    test "não modifica quando os parâmetros são iguais ao atual, com tags" do
      tags = insert_list(2, :tag)
      midia = insert(:midia, tags: tags)
      attrs = midia |> Map.from_struct() |> Map.put(:tags, tags)
      assert {:ok, upserted} = Repository.upsert_midia(midia, attrs)
      assert upserted.link == midia.link
      assert length(upserted.tags) == 2
    end

    test "atualiza quando os parâmetros são válidos, com tags" do
      midia = insert(:midia)
      attrs = fixture(:midia)
      tags = insert_list(2, :tag)
      assert {:ok, _} = Repository.upsert_midia(midia, Map.put(attrs, :tags, tags))
    end
  end

  describe "upsert_nucleo_pesquisa/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_nucleo_pesquisa(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:nucleo_pesquisa)
      assert {:ok, _} = Repository.upsert_nucleo_pesquisa(attrs)
    end
  end

  describe "upsert_pesquisador/1" do
    test "não cria quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_pesquisador(%{})
    end

    test "cria quando os parâmetros são válidos" do
      attrs = fixture(:pesquisador)
      assert {:ok, _} = Repository.upsert_pesquisador(attrs)
    end

    test "não atualiza quando os parâmetros são inválidos" do
      pesquisador = insert(:pesquisador)
      assert {:error, _} = Repository.upsert_pesquisador(pesquisador, %{data_inicio_bolsa: nil})
    end

    test "não modifica quando os parâmetros são iguais ao atual" do
      pesquisador = insert(:pesquisador)
      attrs = Map.from_struct(pesquisador)
      assert {:ok, _} = Repository.upsert_pesquisador(pesquisador, attrs)
    end

    test "atualiza quando os parâmetros são válidos" do
      pesquisador = insert(:pesquisador)
      attrs = fixture(:pesquisador)
      assert {:ok, _} = Repository.upsert_pesquisador(pesquisador, attrs)
    end
  end

  describe "upsert_relatorio/1" do
    test "quando os parâmetros são inválidos" do
      assert {:error, _changeset} = Repository.upsert_relatorio_pesquisa(%{})
    end

    test "quando os parâmetros são válidos" do
      attrs = fixture(:relatorio)
      assert {:ok, _} = Repository.upsert_relatorio_pesquisa(attrs)
    end
  end

  describe "upsert_tag/1" do
    test "não cria quando os parâmetros são inválidos" do
      assert {:error, _} = Repository.upsert_tag(%{})
    end

    test "cria quando os parâmetros são válidos" do
      attrs = fixture(:tag)
      assert {:ok, _} = Repository.upsert_tag(attrs)
    end

    test "não atualiza quando os parâmetros são inválidos" do
      tag = insert(:tag)
      assert {:error, _} = Repository.upsert_tag(tag, %{etiqueta: nil})
    end

    test "não modifica quando os parâmetros são iguais ao atual" do
      tag = insert(:tag)
      attrs = Map.from_struct(tag)
      assert {:ok, _} = Repository.upsert_tag(tag, attrs)
    end

    test "atualiza quando os parâmetros são válidos" do
      tag = insert(:tag)
      attrs = fixture(:tag)
      assert {:ok, _} = Repository.upsert_tag(tag, attrs)
    end
  end

  describe "fetch_midia_by_id_publico/1" do
    test "quando o id é inválido" do
      assert {:error, :not_found} = Repository.fetch_midia_by_id_publico("inválido")
    end

    test "quando o id é válido" do
      midia = insert(:midia)
      assert {:ok, _} = Repository.fetch_midia_by_id_publico(midia.id_publico)
    end
  end

  describe "list_categoria/0" do
    test "quando não há nenhum registro" do
      categorias = Repository.list_categoria()
      assert Enum.empty?(categorias)
    end

    test "quando há registros" do
      insert_list(3, :categoria)
      categorias = Repository.list_categoria()
      assert length(categorias) == 3
    end
  end

  describe "list_pesquisador/0" do
    test "quando não há nenhum registro" do
      pesquisadores = Repository.list_pesquisador()
      assert Enum.empty?(pesquisadores)
    end

    test "quando há registros" do
      insert_list(2, :pesquisador)
      pesquisadores = Repository.list_pesquisador()
      assert length(pesquisadores) == 2
    end
  end

  describe "list_relatorios_pesquisa_from_pesquisador/1" do
    test "quando não há nenhum registro" do
      pesquisador = insert(:pesquisador)
      relatorios = Repository.list_relatorios_pesquisa_from_pesquisador(pesquisador.id_publico)
      assert Enum.empty?(relatorios)
    end

    test "quando há registros" do
      pesquisador = insert(:pesquisador)
      insert(:relatorio_anual, pesquisador_id: pesquisador.id_publico)
      insert_list(4, :relatorio_mensal, pesquisador_id: pesquisador.id_publico)
      insert_list(2, :relatorio_trimestral, pesquisador_id: pesquisador.id_publico)

      relatorios = Repository.list_relatorios_pesquisa_from_pesquisador(pesquisador.id_publico)
      assert length(relatorios) == 7
    end
  end

  describe "list_tags_from_midia/1" do
    test "quando não há nenhum registro" do
      midia = insert(:midia, tags: [])
      tags = Repository.list_tags_from_midia(midia.link)
      assert Enum.empty?(tags)
    end

    test "quando há registros" do
      tags = insert_list(4, :tag)
      midia = insert(:midia, tags: tags)
      listed = Repository.list_tags_from_midia(midia.link)
      assert length(listed) == 4
    end
  end
end
