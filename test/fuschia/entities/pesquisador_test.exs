defmodule Fuschia.Entities.PesquisadorTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Entities.Pesquisador

  describe "changeset/2" do
    @invalid_params %{
      usuario_cpf: nil,
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador_cpf: nil,
      campus_id: nil
    }

    test "when all params are valid, return a valid changeset" do
      default_params = params_for(:pesquisador)
      assert %Ecto.Changeset{valid?: true} = Pesquisador.changeset(%Pesquisador{}, default_params)
    end

    test "when params are invalid, return an error changeset" do
      assert %Ecto.Changeset{valid?: false} =
               Pesquisador.changeset(%Pesquisador{}, @invalid_params)
    end
  end
end
