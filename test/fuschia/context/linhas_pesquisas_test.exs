defmodule Fuschia.Context.LinhasPesquisasTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.LinhasPesquisas
  alias Fuschia.Entities.LinhaPesquisa

  describe "list/0" do
    test "return all linha_pesquisas in database" do
      linha_pesquisa =
        :linha_pesquisa
        |> insert()
        |> LinhasPesquisas.preload_all()

      assert [linha_pesquisa] == LinhasPesquisas.list()
    end
  end

  describe "list_by_nucleo/1" do
    test "return all linha_pesquisas in database" do
      linha_pesquisa =
        :linha_pesquisa
        |> insert()
        |> LinhasPesquisas.preload_all()

      assert [linha_pesquisa] == LinhasPesquisas.list_by_nucleo(linha_pesquisa.nucleo_nome)
    end
  end

  describe "one/1" do
    test "when numero is valid, returns a linha_pesquisa" do
      linha_pesquisa =
        :linha_pesquisa
        |> insert()
        |> LinhasPesquisas.preload_all()

      assert linha_pesquisa == LinhasPesquisas.one(linha_pesquisa.numero)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(LinhasPesquisas.one(0))
    end
  end

  describe "create/1" do
    @invalid_attrs %{
      numero: nil,
      nucleo_nome: nil,
      descricao_curta: nil,
      descricao_longa: nil
    }

    test "when all params are valid, creates an admin linha_pesquisa" do
      attrs = params_for(:linha_pesquisa)
      assert {:ok, %LinhaPesquisa{}} = LinhasPesquisas.create(attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = LinhasPesquisas.create(@invalid_attrs)
    end
  end

  describe "update/1" do
    @update_attrs %{
      numero: 100,
      descricao_curta: "Descricao Curta Teste",
      descricao_longa: "Descricao Longa Teste"
    }

    @invalid_attrs %{
      numero: nil,
      nucleo_nome: nil,
      descricao_curta: nil,
      descricao_longa: nil
    }

    test "when all params are valid, updates a linha_pesquisa" do
      attrs = params_for(:linha_pesquisa)
      assert {:ok, linha_pesquisa} = LinhasPesquisas.create(attrs)

      assert {:ok, updated_linha_pesquisa} =
               LinhasPesquisas.update(linha_pesquisa.numero, @update_attrs)

      assert updated_linha_pesquisa.numero == @update_attrs.numero
      assert updated_linha_pesquisa.descricao_curta == @update_attrs.descricao_curta
      assert updated_linha_pesquisa.descricao_longa == @update_attrs.descricao_longa
    end

    test "when params are invalid, returns an error changeset" do
      attrs = params_for(:linha_pesquisa)
      assert {:ok, linha_pesquisa} = LinhasPesquisas.create(attrs)

      assert {:error, %Ecto.Changeset{}} =
               LinhasPesquisas.update(linha_pesquisa.numero, @invalid_attrs)
    end
  end
end
