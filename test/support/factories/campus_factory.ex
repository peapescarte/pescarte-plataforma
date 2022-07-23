defmodule Fuschia.CampusFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.ModuloPesquisa.Models.Campus

      @spec campus_factory :: Campus.t()
      def campus_factory do
        cidade = insert(:cidade)

        %Campus{
          id: Nanoid.generate_non_secure(),
          nome: sequence(:nome, &"Campus #{&1}"),
          cidade: cidade,
          sigla: sequence(:sigla, &"C#{&1}")
        }
      end
    end
  end
end
