defmodule Backend.Accounts.Models.UserTest do
  use Backend.DataCase, async: true

  import Backend.Factory

  alias Backend.Accounts.Models.User

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{
      cpf: nil,
      contato: nil,
      data_nascimento: nil,
      nome_completo: nil
    }

    test "when all params are valid, return a valid changeset" do
      contato_params = params_for(:contato)

      default_params =
        :user
        |> params_for()
        |> Map.put(:contato, contato_params)

      assert %Ecto.Changeset{valid?: true} = User.changeset(%User{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = User.changeset(%User{}, @invalid_params)
    end
  end

  describe "admin_changeset/2" do
    @invalid_params %{
      cpf: nil,
      perfil: nil,
      contato: nil,
      data_nascimento: nil,
      nome_completo: nil
    }

    test "when all params are valid, return a valid changeset" do
      contato = params_for(:contato)

      default_params =
        :user
        |> params_for()
        |> Map.put(:contato, contato)
        |> Map.put(:perfil, "admin")

      assert %Ecto.Changeset{valid?: true} = User.changeset(%User{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = User.changeset(%User{}, @invalid_params)
    end
  end

  describe "registration_changeset/2" do
    @invalid_params %{
      cpf: nil,
      contato: nil,
      data_nascimento: nil,
      nome_completo: nil,
      password: nil,
      password_confirmation: nil
    }

    test "when all params are valid, return a valid changeset" do
      contato = params_for(:contato)

      default_params =
        :user
        |> params_for()
        |> Map.put(:contato, contato)
        |> Map.merge(%{password: "minhaSenha123", password_confirmation: "minhaSenha123"})

      assert %Ecto.Changeset{valid?: true} = User.registration_changeset(%User{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} =
               User.registration_changeset(%User{}, @invalid_params)
    end
  end
end
