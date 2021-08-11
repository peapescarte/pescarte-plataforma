defmodule Fuschia.UniversidadeFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Universidade

      def universidade_factory do
        %Universidade{
          nome: sequence(:nome, &"Universidade #{&1}"),
          cidade: build(:cidade)
        }
      end
    end
  end
end
