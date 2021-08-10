defmodule Fuschia.UniversidadeFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Universidade

      def universidade_factory do
        %{municipio: cidade_municipio} = insert(:cidade)

        %Universidade{
          nome: sequence(:nome_completo, &"Universidade #{&1}"),
          cidade_municipio: cidade_municipio
        }
      end
    end
  end
end
