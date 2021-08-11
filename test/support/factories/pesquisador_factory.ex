defmodule Fuschia.PesquisadorFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Pesquisador

      def pesquisador_factory do
        user = insert(:user)
        universidade = insert(:universidade)

        %Pesquisador{
          cpf_usuario: user.cpf,
          minibibliografia:
            sequence(:minibibliografia, &"Esta e minha minibibliografia gerada: #{&1}"),
          tipo_bolsa: sequence(:tipo_bolsa, ["ic", "pesquisador"]),
          link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
          orientador_id: nil,
          universidade_id: universidade.id
        }
      end
    end
  end
end
