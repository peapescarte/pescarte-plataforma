defmodule Fuschia.Queries.CampiTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Db
  alias Fuschia.Entities.Campus
  alias Fuschia.Queries.Campi

  describe "list/0" do
    test "return all campi in database" do
      insert(:campus)

      campus = Db.one(Campi.query())

      assert [campus] == Db.list(Campi.query())
    end
  end

  describe "list_by_municipio/1" do
    test "return all campi in database" do
      insert(:campus)

      campus = Db.one(Campi.query())

      assert [campus] == campus.cidade_municipio |> Campi.query_by_municipio() |> Db.list()
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a campus" do
      insert(:campus)

      campus = Db.one(Campi.query())

      assert campus == Db.get(Campi.query(), campus.nome)
    end

    test "when id is invalid, returns nil" do
      assert Campi.query() |> Db.get("") |> is_nil()
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
      assert {:ok, %Campus{}} = Db.create(Campus, @valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Db.create(Campus, @invalid_attrs)
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

      assert {:ok, %Campus{}} =
               Db.create_with_custom_changeset(Campus, &Campus.foreign_changeset/2, @valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Db.create_with_custom_changeset(
                 Campus,
                 &Campus.foreign_changeset/2,
                 @invalid_attrs
               )
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
      assert {:ok, campus} = Db.create(Campus, @valid_attrs)

      assert {:ok, updated_campus} =
               Db.update(Campi.query(), &Campus.foreign_changeset/2, campus.nome, @update_attrs)

      assert updated_campus.nome == @update_attrs.nome
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, campus} = Db.create(Campus, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Db.update(Campi.query(), &Campus.foreign_changeset/2, campus.nome, @invalid_attrs)
    end
  end
end
