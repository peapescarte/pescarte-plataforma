defmodule Fuschia.UserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.User

      @spec user_factory :: User.t()
      def user_factory do
        %User{
          perfil: sequence(:perfil, ["avulso", "pesquisador"]),
          nome_completo: sequence(:nome_completo, &"User #{&1}"),
          ativo: true,
          cpf: sequence(:cpf, ["325.956.490-00", "726.541.170-65"]),
          data_nascimento: sequence(:data_nascimento, [~D[2001-07-27], ~D[2001-07-28]]),
          password_hash: "$2b$12$iWNYYuxNcQhaUuJ82jLKu..jbrQQl8..it6K5AvdVovOwDmLX2OVu",
          contato: build(:contato)
        }
      end
    end
  end
end
