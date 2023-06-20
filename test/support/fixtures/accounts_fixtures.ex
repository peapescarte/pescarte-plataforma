defmodule Pescarte.AccountsFixtures do
  @moduledoc """
  Defines test helpers for creating entities via the `Pescarte.Accounts` domain.
  """

  import Pescarte.Factory

  alias Comeonin.PasswordHash
  alias Pescarte.Domains.Accounts

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.create_user_pesquisador()

    user
  end

  defp valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      senha: "Password123@",
      senha_confirmation: "Password123@",
      primeiro_nome: "Teste",
      sobrenome: "da Silva",
      data_nascimento: ~D[1990-01-25],
      confirmed_at: NaiveDateTime.utc_now(),
      cpf: "902.574.830-98",
      contato_id: insert(:contato).id
    })
  end
end
