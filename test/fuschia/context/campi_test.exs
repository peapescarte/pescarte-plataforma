defmodule Fuschia.Context.CampiTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Campi
  alias Fuschia.Entities.Campus

  describe "list/0" do
    test "return all campi in database" do
      campus =
        :campus
        |> insert()
        |> Campi.preload_all()

      assert [campus] == Campi.list()
    end
  end

  describe "list_by_municipio/1" do
    test "return all campi in database" do
      campus =
        :campus
        |> insert()
        |> Campi.preload_all()

      assert [campus] == Campi.list_by_municipio(campus.cidade_municipio)
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a campus" do
      campus =
        :campus
        |> insert()
        |> Campi.preload_all()

      assert campus == Campi.one(campus.nome)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Campi.one(""))
    end
  end

  describe "create_with_cidade/1" do
    @valid_attrs %{
      nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
      cidade: %{municipio: "Campos dos Goytacazes"}
    }

    @invalid_attrs %{
      nome: nil,
      cidade: nil
    }

    test "when all params are valid, creates an admin campus" do
      assert {:ok, %Campus{}} = Campi.create_with_cidade(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campi.create_with_cidade(@invalid_attrs)
    end
  end

  describe "create/1" do
    @valid_attrs %{
      nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
      cidade_municipio: "Campos Dos Goytacazes"
    }

    @invalid_attrs %{
      nome: nil,
      cidade_municipio: nil
    }

    test "when all params are valid, creates an admin campus" do
      insert(:cidade, municipio: "Campos dos Goytacazes")
      assert {:ok, %Campus{}} = Campi.create(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campi.create(@invalid_attrs)
    end
  end

  describe "update/1" do
    @valid_attrs %{
      nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
      cidade: %{municipio: "Campos dos Goytacazes"}
    }

    @update_attrs %{
      nome: "Campus Federal De São Carlos"
    }

    @invalid_attrs %{
      nome: nil
    }

    test "when all params are valid, updates a campus" do
      assert {:ok, campus} = Campi.create_with_cidade(@valid_attrs)

      assert {:ok, updated_campus} = Campi.update(campus.nome, @update_attrs)

      assert updated_campus.nome == @update_attrs.nome
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, campus} = Campi.create_with_cidade(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Campi.update(campus.nome, @invalid_attrs)
    end
  end
end
