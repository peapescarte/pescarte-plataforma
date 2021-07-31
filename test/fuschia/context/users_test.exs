defmodule Fuschia.Context.UsersTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Users

  describe "list/1" do
    test "return all users in database" do
      user =
        :user
        |> insert()
        |> Users.preload_all()

      assert [user] == Users.list()
    end
  end

  describe "one/1" do
    test "when id is valid, return user" do
      user =
        :user
        |> insert()
        |> Users.preload_all()

      assert user == Users.one(user.id)
    end

    test "when id is invalid, return nil" do
      assert is_nil(Users.one(0))
    end
  end

  describe "one_by_email/1" do
    test "when email is valid, return user" do
      user =
        :user
        |> insert()
        |> Users.preload_all()

      assert user == Users.one_by_email(user.contato.email)
    end

    test "when email is invalid, return nil" do
      assert is_nil(Users.one_by_email(""))
    end
  end
end
