defmodule Fuschia.CampusFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Campus

      def campus_factory do
        cidade = insert(:cidade)

        %Campus{
          id: sequence(:id, Enum.to_list(1..12)),
          nome: sequence(:nome, &"Campus #{&1}"),
          cidade: cidade
        }
      end
    end
  end
end
