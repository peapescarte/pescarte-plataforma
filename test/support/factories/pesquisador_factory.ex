defmodule Fuschia.PesquisadorFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.ModuloPesquisa.Models.PesquisadorModel

      @spec pesquisador_factory :: Pesquisador.t()
      def pesquisador_factory do
        campus = insert(:campus)
        usuario = build(:user)

        %PesquisadorModel{
          id: Nanoid.generate_non_secure(),
          usuario: usuario,
          minibiografia: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
          tipo_bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
          link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
          campus_nome: campus.nome
        }
      end
    end
  end
end
