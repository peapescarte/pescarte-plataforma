defmodule Fuschia.ModuloPesquisa.Models.CampusTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.ModuloPesquisa.Models.Campus

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{nome: nil, cidade: nil}

    test "when all params are valid, return a valid changeset" do
      cidade = params_for(:cidade)

      default_params =
        :campus
        |> params_for()
        |> Map.put(:cidade, cidade)

      assert %Ecto.Changeset{valid?: true} = Campus.changeset(%Campus{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = Campus.changeset(%Campus{}, @invalid_params)
    end
  end
end
