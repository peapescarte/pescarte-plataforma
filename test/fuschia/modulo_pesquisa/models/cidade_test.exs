defmodule Fuschia.ModuloPesquisa.Models.CidadeTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.ModuloPesquisa.Models.Cidade

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{municipio: nil}

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:cidade)
      assert %Ecto.Changeset{valid?: true} = Cidade.changeset(%Cidade{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = Cidade.changeset(%Cidade{}, @invalid_params)
    end
  end
end
