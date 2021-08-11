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
      universidade =
        :universidade
        |> insert()
        |> Universidades.preload_all()

      assert universidade == Universidades.one(universidade.nome)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Universidades.one(""))
    end
  end

  describe "create_with_cidade/1" do
    @valid_attrs %{
      nome: "Universidade Estadual do Norte Fluminence Darcy Ribeiro",
      cidade: %{municipio: "Campos dos Goytacazes"}
    }

    @invalid_attrs %{
      nome: nil,
      cidade: nil
    }

    test "when all params are valid, creates an admin universidade" do
      assert {:ok, %Universidade{}} = Universidades.create_with_cidade(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Universidades.create_with_cidade(@invalid_attrs)
    end
  end

  describe "create/1" do
    @valid_attrs %{
      nome: "Universidade Estadual do Norte Fluminence Darcy Ribeiro",
      cidade_municipio: "Campos Dos Goytacazes"
    }

    @invalid_attrs %{
      nome: nil,
      cidade_municipio: nil
    }

    test "when all params are valid, creates an admin universidade" do
      insert(:cidade, municipio: "Campos dos Goytacazes")
      assert {:ok, %Universidade{}} = Universidades.create(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Universidades.create(@invalid_attrs)
    end
  end

  describe "update/1" do
    @valid_attrs %{
      nome: "Universidade Estadual do Norte Fluminence Darcy Ribeiro",
      cidade: %{municipio: "Campos dos Goytacazes"}
    }

    @update_attrs %{
      nome: "Universidade Federal De São Carlos"
    }

    @invalid_attrs %{
      nome: nil
    }

    test "when all params are valid, updates a universidade" do
      assert {:ok, universidade} = Universidades.create_with_cidade(@valid_attrs)

      assert {:ok, updated_universidade} = Universidades.update(universidade.nome, @update_attrs)

      assert updated_universidade.nome == @update_attrs.nome
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, universidade} = Universidades.create_with_cidade(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Universidades.update(universidade.nome, @invalid_attrs)
    end
  end
end
