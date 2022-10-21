defmodule Backend.ModuloPesquisa.Models.LinhaPesquisaTest do
  use Backend.DataCase, async: true

  import Backend.Factory

  alias Backend.ModuloPesquisa.Models.LinhaPesquisa

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{
      numero: nil,
      nucleo_nome: nil,
      descricao_curta: nil,
      descricao_longa: nil
    }

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:linha_pesquisa)

      assert %Ecto.Changeset{valid?: true} =
               LinhaPesquisa.changeset(%LinhaPesquisa{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} =
               LinhaPesquisa.changeset(%LinhaPesquisa{}, @invalid_params)
    end
  end
end
