defmodule Fuschia.LinhaPesquisaFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.LinhaPesquisa

      def linha_pesquisa_factory do
        %LinhaPesquisa{
          numero: sequence(:numero, 1..21),
          descricao_curta: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
          descricao_longa: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
          nucleo: build(:nucleo)
        }
      end
    end
  end
end
