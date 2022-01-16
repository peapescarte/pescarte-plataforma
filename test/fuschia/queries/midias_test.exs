defmodule Fuschia.Queries.MidiasTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Db
  alias Fuschia.Entities.Midia
  alias Fuschia.Queries.Midias

  describe "list/0" do
    test "return all midias in database" do
      insert(:midia)

      midia = Db.one(Midias.query())

      assert [midia] == Db.list(Midias.query())
    end
  end

  describe "list_by_pesquisador/1" do
    test "return all midia in database" do
      insert(:midia)

      midia = Db.one(Midias.query())

      assert [midia] ==
               midia.pesquisador_cpf |> Midias.query_by_pesquisador() |> Db.list()
    end
  end

  describe "one/1" do
    test "when numero is valid, returns a midia" do
      insert(:midia)

      midia = Db.one(Midias.query())

      assert midia == Db.get(Midias.query(), midia.link)
    end

    test "when id is invalid, returns nil" do
      assert Midias.query() |> Db.get("") |> is_nil()
    end
  end

  describe "create/1" do
    @invalid_attrs %{
      link: nil,
      tipo: nil,
      tags: nil,
      pesquisador_cpf: nil
    }

    test "when all params are valid, creates a midia" do
      valid_attrs = params_for(:midia)

      assert {:ok, %Midia{}} = Db.create(Midia, valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Db.create(Midia, @invalid_attrs)
    end
  end

  describe "update/1" do
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

    test "when all params are valid, updates a midia" do
      attrs = params_for(:midia)

      assert {:ok, midia} = Db.create(Midia, attrs)

      assert {:ok, updated_midia} =
               Db.update(
                 Midias.query(),
                 &Midia.changeset/2,
                 midia.link,
                 @update_attrs
               )

      assert updated_midia.link == @update_attrs.link
      assert updated_midia.tipo == @update_attrs.tipo
      assert updated_midia.tags == @update_attrs.tags
    end

    test "when params are invalid, returns an error changeset" do
      attrs = params_for(:midia)

      assert {:ok, midia} = Db.create(Midia, attrs)

      assert {:error, %Ecto.Changeset{}} =
               Db.update(
                 Midias.query(),
                 &Midia.changeset/2,
                 midia.link,
                 @invalid_attrs
               )
    end
  end
end
