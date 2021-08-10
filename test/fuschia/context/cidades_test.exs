defmodule Fuschia.Context.CidadesTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Cidades
  alias Fuschia.Entities.Cidade

  describe "list/0" do
    test "return all cidades in database" do
      cidade =
        :cidade
        |> insert()
        |> Cidades.preload_all()

      assert [cidade] == Cidades.list()
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a cidade" do
      cidade =
        :cidade
        |> insert()
        |> Cidades.preload_all()

      assert cidade == Cidades.one(cidade.municipio)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Cidades.one(""))
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
      assert {:ok, %Cidade{}} = Cidades.create(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cidades.create(@invalid_attrs)
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
      assert {:ok, cidade} = Cidades.create(@valid_attrs)

      assert {:ok, updated_cidade} = Cidades.update(cidade.municipio, @update_attrs)

      assert updated_cidade.municipio == @update_attrs.municipio
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, cidade} = Cidades.create(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Cidades.update(cidade.municipio, @invalid_attrs)
    end
  end
end
