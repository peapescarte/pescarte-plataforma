defmodule Fuschia.PesquisadorFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.ModuloPesquisa.Models.Pesquisador

      @spec pesquisador_factory :: Pesquisador.t()
      def pesquisador_factory do
        campus = insert(:campus)
        usuario = build(:user)

        %Pesquisador{
          id: Nanoid.generate_non_secure(),
          usuario: usuario,
          minibiografia: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
          tipo_bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
          link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
          campus_sigla: campus.sigla
        }
      end
    end
  end
end
