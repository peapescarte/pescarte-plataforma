defmodule Backend.ModuloPesquisa.Models.RelatorioTest do
  use Backend.DataCase, async: true

  import Backend.Factory

  alias Backend.ModuloPesquisa.Models.Relatorio

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{
      ano: nil,
      mes: nil,
      tipo: nil,
      link: nil,
      pesquisador_cpf: nil
    }

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:relatorio)

      assert %Ecto.Changeset{valid?: true} = Relatorio.changeset(%Relatorio{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} = Relatorio.changeset(%Relatorio{}, @invalid_params)
    end
  end
end
