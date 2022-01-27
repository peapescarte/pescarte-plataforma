defmodule Fuschia.NucleoFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Nucleo

      @spec nucleo_factory :: Nucleo.t()
      def nucleo_factory do
        %Nucleo{
          id_externo: Nanoid.generate_non_secure(),
          nome: sequence(:nome, &"Nucleo #{&1}"),
          descricao: sequence(:descricao, &"Descricao Nucleo #{&1}")
        }
      end
    end
  end
end
