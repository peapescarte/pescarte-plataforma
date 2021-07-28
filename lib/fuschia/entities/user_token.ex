defmodule Fuschia.Entities.UserToken do
  @moduledoc """
  Defines structure of a secure and random token to
  user be able to reset password, change email or confirm
  registration
  """

  use Fuschia.Schema

  alias Fuschia.Entities.User

  @hash_algorithm :sha256
  @rand_size 32

  schema "users_token" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string

    belongs_to :user, User

    timestamps(updated_at: false)
  end

  @doc """
  Builds a token with a hashed counter part.

  The non-hashed token is sent to the user email while the
  hashed part is stored in the database, to avoid reconstruction.
  The token is valid for a week as long as users don't change
  their email.
  """
  def build_email_token(user, context) do
    build_hashed_token(user, context, user.email)
  end

  defp build_hashed_token(user, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %Fuschia.Entities.UserToken{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       user_id: user.id
     }}
  end
end
