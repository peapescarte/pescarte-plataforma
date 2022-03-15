defmodule Fuschia.Accounts.Models.UserToken do
  @moduledoc """
  Schema que representa tokens de usuários.

  ## Exemplos
  - confirmação de email
  - recuperação de senha
  - token de sessão de login
  """

  use Fuschia.Schema

  alias Fuschia.Accounts.Models.User
  alias Fuschia.Types.TrimmedString

  schema "user_token" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string

    belongs_to :user, User,
      foreign_key: :user_cpf,
      references: :cpf,
      type: TrimmedString

    timestamps(updated_at: false)
  end
end
