defmodule Fuschia.Context.UsersTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Users
  alias Fuschia.Entities.User

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
    test "when id is valid, returns a user" do
      user =
        :user
        |> insert()
        |> Users.preload_all()

      assert user == Users.one(user.cpf)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Users.one(""))
    end
  end

  describe "one_by_email/1" do
    test "when email is valid, returns a user" do
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

  describe "create/1" do
    @valid_attrs %{
      nome_completo: "Matheus de Souza Pessanha",
      cpf: "264.722.590-70",
      data_nascimento: ~D[2001-07-27],
      perfil: "admin",
      contato: %{
        endereco: "Av Teste, Rua Teste, numero 123",
        email: "teste@exemplo.com",
        celular: "(22)12345-6789"
      }
    }

    @invalid_attrs %{
      nome_completo: nil,
      cpf: nil,
      data_nascimento: nil,
      perfil: nil,
      contato: nil
    }

    test "when all params are valid, creates an admin user" do
      assert {:ok, %User{}} = Users.create(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create(@invalid_attrs)
    end
  end

  describe "register/1" do
    @valid_attrs %{
      nome_completo: "Matheus de Souza Pessanha",
      cpf: "264.722.590-70",
      data_nascimento: ~D[2001-07-27],
      contato: %{
        endereco: "Av Teste, Rua Teste, numero 123",
        email: "teste@exemplo.com",
        celular: "(22)12345-6789"
      },
      password: "Teste1234",
      password_confirmation: "Teste1234"
    }

    @invalid_attrs %{
      nome_completo: nil,
      cpf: nil,
      data_nascimento: nil,
      contato: nil,
      password: nil,
      password_confirmation: nil
    }

    test "when all params are valid, creates an 'avulso' user" do
      assert {:ok, %User{perfil: "avulso"}} = Users.register(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.register(@invalid_attrs)
    end
  end

  describe "update/1" do
    @valid_attrs %{
      nome_completo: "Matheus de Souza Pessanha",
      cpf: "264.722.590-70",
      data_nascimento: ~D[2001-07-27],
      contato: %{
        endereco: "Av Teste, Rua Teste, numero 123",
        email: "teste@exemplo.com",
        celular: "(22)12345-6789"
      },
      password: "Teste1234",
      password_confirmation: "Teste1234"
    }

    @update_attrs %{
      cpf: "435.618.970-10",
      nome_completo: "Juninho teste",
      data_nascimento: ~D[1990-07-27],
      contato: %{
        endereco: "Av Teste, Rua Teste, numero 765",
        email: "teste@exemplo2.com",
        celular: "(22)12345-6710"
      }
    }

    @invalid_attrs %{
      nome_completo: nil,
      cpf: nil,
      data_nascimento: nil,
      contato: nil,
      password: nil,
      password_confirmation: nil
    }

    test "when all params are valid, updates a user" do
      assert {:ok, user} = Users.register(@valid_attrs)
      assert {:ok, updated_user} = Users.update(user.cpf, @update_attrs)

      for key <- Map.keys(@update_attrs) do
        if key == :contato do
          contato = Map.get(updated_user, key)
          contato_attrs = Map.get(@update_attrs, key)
          assert contato.email == contato_attrs.email
          assert contato.endereco == contato_attrs.endereco
          assert contato.celular == contato_attrs.celular
        else
          assert Map.get(updated_user, key) == Map.get(@update_attrs, key)
        end
      end
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, user} = Users.register(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Users.update(user.cpf, @invalid_attrs)
    end
  end

  describe "exists?/1" do
    test "when id is valid, returns true" do
      user = insert(:user)
      assert true == Users.exists?(user.cpf)
    end

    test "when id is invalid, returns false" do
      assert false == Users.exists?("")
    end
  end
end
