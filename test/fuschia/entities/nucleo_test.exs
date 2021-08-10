defmodule Fuschia.Entities.NucleoTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Entities.Nucleo

  describe "changeset/2" do
    @invalid_params %{
      nome: nil,
      descricao: nil
    }

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:nucleo)
      assert %Ecto.Changeset{valid?: true} = Nucleo.changeset(%Nucleo{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = Nucleo.changeset(%Nucleo{}, @invalid_params)
    end
  end
end
