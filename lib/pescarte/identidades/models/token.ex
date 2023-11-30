defmodule Pescarte.Identidades.Models.Token do
  @moduledoc """
  Schema que representa tokens de usuários.

  ## Exemplos
  - confirmação de email
  - recuperação de senha
  - token de sessão de login
  """

  use Pescarte, :model

  import Ecto.Query

  alias Pescarte.Identidades.Models.Usuario

  @type t :: %Token{
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

    belongs_to :usuario, Usuario,
      foreign_key: :usuario_id,
      references: :id_publico,
      type: :string

    timestamps(updated_at: false)
  end

  @spec changeset(map) :: changeset
  def changeset(attrs) do
    %Token{}
    |> cast(attrs, [:token, :contexto, :enviado_para, :usuario_id])
    |> validate_required([:token, :contexto, :usuario_id])
  end

  @doc """
  Obtém todos os tokens do usuário fornecido para os contextos fornecidos.
  """
  def user_and_contexts_query(user, :all) do
    from t in Token, where: t.usuario_id == ^user.id_publico
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in Token, where: t.usuario_id == ^user.id_publico and t.contexto in ^contexts
  end
end
