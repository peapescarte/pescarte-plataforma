defmodule Fuschia.MidiaFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Midia

      @spec midia_factory :: Midia.t()
      def midia_factory do
        pesquisador = insert(:pesquisador)

        %Midia{
          id: Nanoid.generate_non_secure(),
          pesquisador: pesquisador,
          tipo: sequence(:tipo, ["video", "documento", "imagem"]),
          link: sequence(:link, &"https://example#{&1}.com"),
          tags: []
        }
      end
    end
  end
end
