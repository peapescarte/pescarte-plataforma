defmodule Fuschia.Entities.PesquisadorTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Entities.Pesquisador

  @moduletag :unit

  describe "changeset/2" do
    @invalid_params %{
      usuario_cpf: nil,
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador_cpf: nil,
      campus_nome: nil
    }

    test "when all params are valid, return a valid changeset" do
      usuario_params =
        :user
        |> params_for()
        |> Map.put(:contato, params_for(:contato))

      default_params =
        :pesquisador
        |> params_for()
        |> Map.put(:usuario, usuario_params)

      assert %Ecto.Changeset{valid?: true} = Pesquisador.changeset(%Pesquisador{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} =
               Pesquisador.changeset(%Pesquisador{}, @invalid_params)
    end
  end
end
