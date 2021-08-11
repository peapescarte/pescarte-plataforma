defmodule Fuschia.NucleoFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Nucleo

      def nucleo_factory do
        %Nucleo{
          nome: sequence(:nome, &"Nucleo #{&1}"),
          descricao: sequence(:descricao, &"Descricao Nucleo #{&1}")
        }
      end
    end
  end
end
