defmodule Pescarte.Domains.Accounts.Models.UserToken do
  @moduledoc """
  Schema que representa tokens de usuários.

  ## Exemplos
  - confirmação de email
  - recuperação de senha
  - token de sessão de login
  """

  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.User

  schema "user_token" do
    field :token, :binary
    field :contexto, :string
    field :enviado_para, :string

    belongs_to :usuario, User

    timestamps(updated_at: false)
  end
end
