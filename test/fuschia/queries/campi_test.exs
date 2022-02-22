defmodule Fuschia.Queries.CampiTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Database
  alias Fuschia.Entities.Campus
  alias Fuschia.Queries.Campi

  @moduletag :unit

  describe "list/0" do
    test "return all campi in database" do
      insert(:campus)

      campus = Database.one(Campi.query())

      assert [campus] == Database.list(Campi.query())
    end
  end

  describe "list_by_municipio/1" do
    test "return all campi in database" do
      insert(:campus)

      campus = Database.one(Campi.query())

      assert [campus] == campus.cidade_municipio |> Campi.query_by_municipio() |> Database.list()
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a campus" do
      insert(:campus)

      campus = Database.one(Campi.query())

      assert campus == Database.get(Campi.query(), campus.nome)
    end

    test "when id is invalid, returns nil" do
      assert Campi.query() |> Database.get("") |> is_nil()
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
      assert {:ok, %Campus{}} = Database.create(Campus, @valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Database.create(Campus, @invalid_attrs)
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
               Database.create_with_custom_changeset(
                 Campus,
                 &Campus.foreign_changeset/2,
                 @valid_attrs
               )
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Database.create_with_custom_changeset(
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
      assert {:ok, campus} = Database.create(Campus, @valid_attrs)

      assert {:ok, updated_campus} =
               Database.update(
                 Campi.query(),
                 &Campus.foreign_changeset/2,
                 campus.nome,
                 @update_attrs
               )

      assert updated_campus.nome == @update_attrs.nome
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, campus} = Database.create(Campus, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Database.update(
                 Campi.query(),
                 &Campus.foreign_changeset/2,
                 campus.nome,
                 @invalid_attrs
               )
    end
  end
end
