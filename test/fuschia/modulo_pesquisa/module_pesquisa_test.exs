defmodule Fuschia.ModuloPesquisaTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.ModuloPesquisa

  alias Fuschia.ModuloPesquisa.Models.{
    Campus,
    Cidade,
    LinhaPesquisa,
    Midia,
    Nucleo,
    Pesquisador,
    Relatorio
  }

  @moduletag :integration

  describe "campus" do
    @valid_attrs %{
      nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
      cidade_municipio: "Campos Dos Goytacazes"
    }

    @valid_attrs_cidade %{
      nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
      cidade: %{municipio: "Campos dos Goytacazes"}
    }

    @invalid_attrs %{
      nome: nil,
      cidade: nil
    }

    test "create_campus/1" do
      assert {:ok, %Campus{}} = ModuloPesquisa.create_campus(@valid_attrs_cidade)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_campus(@invalid_attrs)
    end

    test "create_campus/2" do
      insert(:cidade, municipio: "Campos dos Goytacazes")

      assert {:ok, %Campus{}} =
               ModuloPesquisa.create_campus(@valid_attrs, change_fun: &Campus.foreign_changeset/2)

      assert {:error, %Ecto.Changeset{}} =
               ModuloPesquisa.create_campus(@invalid_attrs,
                 change_fun: &Campus.foreign_changeset/2
               )
    end

    test "list_campus/0" do
      insert(:campus)

      campi = ModuloPesquisa.list_campus()

      assert length(campi) > 0
    end

    test "get_campus/1" do
      campus = insert(:campus)

      assert ModuloPesquisa.get_campus(campus.nome)
      refute ModuloPesquisa.get_campus("")
    end
  end

  describe "cidade" do
    @valid_attrs %{
      municipio: "Campos dos Goytacazes"
    }

    @invalid_attrs %{
      municipio: nil
    }

    test "create_cidade/1" do
      assert {:ok, %Cidade{}} = ModuloPesquisa.create_cidade(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_cidade(@invalid_attrs)
    end

    test "get_cidade/1" do
      cidade = insert(:cidade)

      assert ModuloPesquisa.get_cidade(cidade.municipio)
      refute ModuloPesquisa.get_cidade("")
    end
  end

  describe "linha pesquisa" do
    @invalid_attrs %{
      numero: nil,
      nucleo_nome: nil,
      descricao_curta: nil,
      descricao_longa: nil
    }

    test "create_linha_pesquisa/1" do
      valid_attrs = params_for(:linha_pesquisa)
      assert {:ok, %LinhaPesquisa{}} = ModuloPesquisa.create_linha_pesquisa(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_linha_pesquisa(@invalid_attrs)
    end

    test "list_linha_pesquisa/0" do
      insert(:linha_pesquisa)

      linhas_pesquisas = ModuloPesquisa.list_linha_pesquisa()

      assert length(linhas_pesquisas) > 0
    end

    test "list_linha_pesquisa_by_nucleo/1" do
      linha_pesquisa = insert(:linha_pesquisa)

      linhas_pesquisas = ModuloPesquisa.list_linha_pesquisa_by_nucleo(linha_pesquisa.nucleo_nome)

      assert length(linhas_pesquisas) > 0
    end

    test "get_linha_pesquisa/1" do
      linha_pesquisa = insert(:linha_pesquisa)

      assert ModuloPesquisa.get_linha_pesquisa(linha_pesquisa.numero)
      refute ModuloPesquisa.get_linha_pesquisa(0)
    end
  end

  describe "Mídia" do
    @update_attrs %{
      link: "https://example.com",
      tipo: "video",
      tags: []
    }

    @invalid_attrs %{
      link: nil,
      tipo: nil,
      tags: nil,
      pesquisador_cpf: nil
    }

    test "create_midia/1" do
      valid_attrs = params_for(:midia)

      assert {:ok, %Midia{}} = ModuloPesquisa.create_midia(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_midia(@invalid_attrs)
    end

    test "list_midia/0" do
      insert(:midia)

      midias = ModuloPesquisa.list_midia()

      assert length(midias) > 0
    end

    test "get_midia/1" do
      midia = insert(:midia)

      assert ModuloPesquisa.get_midia(midia.link)
      refute ModuloPesquisa.get_midia("")
    end

    test "update_midia/2" do
      midia = insert(:midia)

      assert {:ok, %Midia{}} = ModuloPesquisa.update_midia(midia, @update_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.update_midia(midia, @invalid_attrs)
    end
  end

  describe "Nucleo" do
    @update_attrs %{
      nome: "Nucleo Teste",
      descricao: "Nucleo Descricao Teste"
    }

    @invalid_attrs %{
      nome: nil,
      descricao: nil
    }

    test "create_nucleo/1" do
      valid_attrs = params_for(:nucleo)

      assert {:ok, %Nucleo{}} = ModuloPesquisa.create_nucleo(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_nucleo(@invalid_attrs)
    end

    test "list_nucleo/0" do
      insert(:nucleo)

      nucleos = ModuloPesquisa.list_nucleo()

      assert length(nucleos) > 0
    end

    test "get_nucleo/1" do
      nucleo = insert(:nucleo)

      assert ModuloPesquisa.get_nucleo(nucleo.nome)
      refute ModuloPesquisa.get_nucleo("")
    end

    test "update_nucleo/2" do
      nucleo = insert(:nucleo)

      assert {:ok, %Nucleo{}} = ModuloPesquisa.update_nucleo(nucleo, @update_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.update_nucleo(nucleo, @invalid_attrs)
    end
  end

  describe "Pesquisador" do
    @invalid_attrs %{
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador: nil,
      campus_nome: nil,
      usuario: nil,
      orientandos: nil
    }

    test "create_pesquisador/1" do
      valid_password = valid_user_password()

      campus = insert(:campus)

      contato_attrs = params_for(:contato)

      user_attrs =
        :user
        |> params_for()
        |> Map.put(:contato, contato_attrs)
        |> Map.put(:password, valid_password)
        |> Map.put(:password_confirmation, valid_password)

      valid_attrs =
        :pesquisador
        |> params_for()
        |> Map.put(:campus_nome, campus.nome)
        |> Map.put(:usuario, user_attrs)

      assert {:ok, %Pesquisador{}} = ModuloPesquisa.create_pesquisador(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_pesquisador(@invalid_attrs)
    end

    test "list_pesquisador/0" do
      insert(:pesquisador)

      pesquisadores = ModuloPesquisa.list_pesquisador()

      assert length(pesquisadores) > 0
    end

    test "get_pesquisador/1" do
      pesquisador = insert(:pesquisador)

      assert ModuloPesquisa.get_pesquisador(pesquisador.usuario_cpf)
      refute ModuloPesquisa.get_pesquisador("")
    end
  end

  describe "Relatorio" do
    @invalid_attrs %{
      ano: nil,
      mes: nil,
      link: nil,
      tipo: nil,
      pesquisador_cpf: nil
    }

    test "create_relatorio/1" do
      valid_attrs = params_for(:relatorio)

      assert {:ok, %Relatorio{}} = ModuloPesquisa.create_relatorio(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = ModuloPesquisa.create_relatorio(@invalid_attrs)
    end

    test "list_relatorio/0" do
      insert(:relatorio)

      relatorios = ModuloPesquisa.list_relatorio()

      assert length(relatorios) > 0
    end

    test "get_relatorio/1" do
      relatorio = insert(:relatorio)

      assert ModuloPesquisa.get_relatorio(relatorio.ano, relatorio.mes)
      refute ModuloPesquisa.get_relatorio(0, 0)
    end
  end
end
