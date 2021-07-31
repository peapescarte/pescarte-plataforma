defmodule Fuschia.ContatoFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Contato

      def contato_factory do
        %Contato{
          email: sequence(:email, &"test-#{&1}@example.com"),
          celular: sequence(:celular, &"(11)98765432#{&1}"),
          endereco: sequence(:endereco, &"Teste, Rua teste, número #{&1}")
        }
      end
    end
  end
end
