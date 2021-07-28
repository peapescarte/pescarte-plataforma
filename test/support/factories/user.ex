defmodule Fuschia.UserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.User

      def user_factory(attrs) do
        cpf = Map.get(attrs, :cpf, sequence(:cpf, ["325.956.490-00", "726.541.170-65"]))
        email = Map.get(attrs, :email, sequence(:email, &"test-#{&1}@example.com"))
        nome_completo = sequence(:nome_completo, &"User #{&1})")
        password = Map.get(attrs, :password, "Mdsp9070")
        data_nasc = Map.get(attrs, :data_nasc, ~D[2001-07-27])

        user =
          %User{
            perfil: sequence(:perfil, ["admin", "pesquisador"]),
            nome_completo: nome_completo,
            ativo: true,
            password: password,
            email: email,
            cpf: cpf,
            data_nasc: data_nasc
          }
          |> hash_password()

        user
        |> merge_attributes(attrs)
        |> evaluate_lazy_attributes()
      end

      defp hash_password(%User{password: password} = user) do
        password_hash = Bcrypt.hash_pwd_salt(password)
        %{user | password_hash: password_hash}
      end
    end
  end
end
