defmodule Pescarte.Domains.Accounts.Models.UserToken do
  @moduledoc """
  Schema que representa tokens de usuários.

  ## Exemplos
  - confirmação de email
  - recuperação de senha
  - token de sessão de login
  """

  use Pescarte, :model

  import Ecto.Query

  alias Pescarte.Domains.Accounts.Models.User

  @opaque t :: %UserToken{
            id: integer,
            token: binary,
            contexto: binary,
            enviado_para: binary,
            usuario: User.t()
          }

  schema "user_token" do
    field :token, :binary
    field :contexto, :string
    field :enviado_para, :string

    belongs_to :usuario, User

    timestamps(updated_at: false)
  end

  @spec changeset(map) :: Result.t(UserToken.t(), changeset)
  def changeset(attrs) do
    %UserToken{}
    |> cast(attrs, [:token, :contexto, :enviado_para, :usuario_id])
    |> validate_required([:token, :contexto, :usuario_id])
    |> apply_action(:parse)
  end

  @doc """
  Obtém todos os tokens do usuário fornecido para os contextos fornecidos.
  """
  def user_and_contexts_query(user, :all) do
    from t in UserToken, where: t.usuario_id == ^user.id
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in UserToken, where: t.usuario_id == ^user.id and t.contexto in ^contexts
  end
end
