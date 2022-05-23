defmodule Fuschia.ModuloPesquisa.Models.MidiaTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.ModuloPesquisa.Models.Midia

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{
      tipo: nil,
      tags: nil,
      link: nil,
      pesquisador_cpf: nil
    }

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:midia)

      assert %Ecto.Changeset{valid?: true} = Midia.changeset(%Midia{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = Midia.changeset(%Midia{}, @invalid_params)
    end
  end
end
