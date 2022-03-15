defmodule Fuschia.RelatorioFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.ModuloPesquisa.Models.RelatorioModel

      @spec relatorio_factory :: Relatorio.t()
      def relatorio_factory do
        pesquisador = insert(:pesquisador)

        %RelatorioModel{
          id: Nanoid.generate_non_secure(),
          pesquisador: pesquisador,
          tipo: sequence(:tipo, ["mensal", "trimestral", "anual"]),
          link: sequence(:link, &"https://example#{&1}.com"),
          ano: Date.utc_today().year,
          mes: Date.utc_today().month
        }
      end
    end
  end
end
