defmodule Fuschia.UserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Accounts
      alias Fuschia.Accounts.Models.User
      alias Fuschia.Accounts.Queries.User, as: UserQueries
      alias Fuschia.Database

      def unique_user_email, do: "user#{System.unique_integer()}@example.com"
      def valid_user_password, do: "Hello World 42!"

      @spec user_factory :: User.t()
      def user_factory do
        %User{
          id: Nanoid.generate_non_secure(),
          role: sequence(:role, ["avulso", "pesquisador"]),
          nome_completo: sequence(:nome_completo, &"User #{&1}"),
          ativo?: true,
          cpf: Brcpfcnpj.cpf_generate(true),
          data_nascimento: sequence(:data_nascimento, [~D[2001-07-27], ~D[2001-07-28]]),
          password_hash: "$2b$12$AZdxCkw/Rb5AlI/5S7Ebb.hIyG.ocs18MGkHAW2gdZibH7a1wHTyu",
          contato: build(:contato)
        }
      end

      def user_fixture(opts \\ []) do
        :user
        |> Fuschia.Factory.insert(opts)
        |> Database.preload_all(UserQueries.relationships())
      end

      def extract_user_token(fun) do
        {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
        [_, token | _] = String.split(captured_email.url, "[TOKEN]")
        token
      end
    end
  end
end
