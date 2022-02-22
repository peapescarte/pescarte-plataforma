defmodule Fuschia.Queries.CidadesTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Database
  alias Fuschia.Entities.Cidade
  alias Fuschia.Queries.Cidades

  @moduletag :unit

  describe "list/0" do
    test "return all cidades in database" do
      insert(:cidade)

      cidade = Database.one(Cidades.query())

      assert [cidade] == Database.list(Cidades.query())
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a cidade" do
      insert(:cidade)

      cidade = Database.one(Cidades.query())

      assert cidade == Database.get(Cidades.query(), cidade.municipio)
    end

    test "when id is invalid, returns nil" do
      assert Cidades.query() |> Database.get("") |> is_nil()
    end
  end

  describe "create/1" do
    @valid_attrs %{
      municipio: "Campos dos Goytacazes"
    }

    @invalid_attrs %{
      municipio: nil
    }

    test "when all params are valid, creates an admin cidade" do
      assert {:ok, %Cidade{}} = Database.create(Cidade, @valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Database.create(Cidade, @invalid_attrs)
    end
  end

  describe "update/1" do
    @valid_attrs %{
      municipio: "Campos dos Goytacazes"
    }

    @update_attrs %{
      municipio: "São Carlos"
    }

    @invalid_attrs %{
      municipio: nil
    }

    test "when all params are valid, updates a cidade" do
      assert {:ok, cidade} = Database.create(Cidade, @valid_attrs)

      assert {:ok, updated_cidade} =
               Database.update(
                 Cidades.query(),
                 &Cidade.changeset/2,
                 cidade.municipio,
                 @update_attrs
               )

      assert updated_cidade.municipio == @update_attrs.municipio
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, cidade} = Database.create(Cidade, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Database.update(
                 Cidades.query(),
                 &Cidade.changeset/2,
                 cidade.municipio,
                 @invalid_attrs
               )
    end
  end
end
