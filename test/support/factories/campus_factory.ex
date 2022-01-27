defmodule Fuschia.CampusFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Campus

      @spec campus_factory :: Campus.t()
      def campus_factory do
        cidade = insert(:cidade)

        %Campus{
          id_externo: Nanoid.generate_non_secure(),
          nome: sequence(:nome, &"Campus #{&1}"),
          cidade: cidade
        }
      end
    end
  end
end
