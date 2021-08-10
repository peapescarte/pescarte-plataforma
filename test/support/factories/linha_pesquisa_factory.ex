defmodule Fuschia.LinhaPesquisaFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.LinhaPesquisa

      def linha_pesquisa_factory do
        nucleo = insert(:nucleo)

        %LinhaPesquisa{
          numero: sequence(:numero, Enum.to_list(1..21)),
          descricao_curta: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
          descricao_longa: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
          nucleo_nome: nucleo.nome
        }
      end
    end
  end
end
