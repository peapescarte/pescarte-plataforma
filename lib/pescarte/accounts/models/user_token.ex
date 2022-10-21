defmodule Backend.Accounts.Models.UserToken do
  @moduledoc """
  Schema que representa tokens de usuários.

  ## Exemplos
  - confirmação de email
  - recuperação de senha
  - token de sessão de login
  """

  use Backend, :model

  alias Backend.Accounts.Models.User

  schema "user_token" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string

    belongs_to :user, User

    timestamps(updated_at: false)
  end
end
