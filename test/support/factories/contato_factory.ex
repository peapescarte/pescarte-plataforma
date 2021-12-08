defmodule Fuschia.ContatoFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Contato

      @spec contato_factory :: Contato.t()
      def contato_factory do
        %Contato{
          email: sequence(:email, &"test-#{&1}@example.com"),
          celular: sequence(:celular, ["(22)12345-6789"]),
          endereco: sequence(:endereco, &"Teste, Rua teste, número #{&1}")
        }
      end
    end
  end
end
