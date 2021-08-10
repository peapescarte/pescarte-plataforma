defmodule Fuschia.Context.UniversidadesTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Universidades
  alias Fuschia.Entities.Universidade

  describe "list/0" do
    test "return all universidades in database" do
      universidade =
        :universidade
        |> insert()
        |> Universidades.preload_all()

      assert [universidade] == Universidades.list()
    end
  end

  describe "list_by_municipio/1" do
    test "return all universidades in database" do
      universidade =
        :universidade
        |> insert()
        |> Universidades.preload_all()

      assert [universidade] == Universidades.list_by_municipio(universidade.cidade_municipio)
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a universidade" do
      %{municipio: cidade_municipio} = insert(:cidade)

      universidade =
        :universidade
        |> insert(cidade_municipio: cidade_municipio)
        |> Universidades.preload_all()

      assert universidade == Universidades.one(universidade.nome)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Universidades.one(""))
    end
  end

  describe "create/1" do
    @valid_attrs %{
      nome: "Universidade Estadual do Norte Fluminence Darcy Ribeiro",
      cidade_municipio: "Campos dos Goytacazes"
    }

    @invalid_attrs %{
      nome: nil,
      cidade: nil
    }

    test "when all params are valid, creates an admin universidade" do
      %{municipio: cidade_municipio} = insert(:cidade)

      assert {:ok, %Universidade{}} =
               @valid_attrs
               |> Map.put(:cidade_municipio, cidade_municipio)
               |> Universidades.create()
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Universidades.create(@invalid_attrs)
    end
  end

  describe "update/1" do
    setup do
      %{cidade: insert(:cidade)}
    end

    @valid_attrs %{
      nome: "Universidade Estadual do Norte Fluminence Darcy Ribeiro"
    }

    @update_attrs %{
      nome: "Universidade Federal de São Carlos"
    }

    @invalid_attrs %{
      nome: nil,
      cidade_municipio: nil
    }

    test "when all params are valid, updates a universidade", %{cidade: cidade} do
      assert {:ok, universidade} =
               @valid_attrs
               |> Map.put(:cidade_municipio, cidade.municipio)
               |> Universidades.create()

      assert {:ok, updated_universidade} = Universidades.update(universidade.nome, @update_attrs)

      assert updated_universidade.nome == @update_attrs.nome
      assert updated_universidade.cidade_municipio == cidade.municipio
    end

    test "when params are invalid, returns an error changeset", %{cidade: cidade} do
      assert {:ok, universidade} =
               @valid_attrs
               |> Map.put(:cidade_municipio, cidade.municipio)
               |> Universidades.create()

      assert {:error, %Ecto.Changeset{}} = Universidades.update(universidade.nome, @invalid_attrs)
    end
  end
end
