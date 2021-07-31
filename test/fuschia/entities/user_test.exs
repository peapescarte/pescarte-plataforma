defmodule Fuschia.Entities.UserTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Entities.User

  describe "changeset/2" do
    @invalid_params %{
      cpf: nil,
      contato: nil,
      data_nascimento: nil,
      nome_completo: nil,
      password: nil,
      password_confirmation: nil
    }

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:user)
      assert %Ecto.Changeset{valid?: true} = User.changeset(%User{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = User.changeset(%User{}, @invalid_params)
    end
  end
end
