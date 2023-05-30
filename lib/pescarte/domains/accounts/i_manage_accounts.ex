defmodule Pescarte.Domains.Accounts.IManageAccounts do
  alias Monads.Result
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Models.UserToken

  @typep changeset :: Ecto.Changeset.t()

  @callback confirm_user(binary, NaiveDateTime.t()) :: Result.t(User.t(), changeset)

  @callback create_user_admin(map) :: Result.t(User.t(), changeset)
  @callback create_user_avulso(map) :: Result.t(User.t(), changeset)
  @callback create_user_pesquisador(map) :: Result.t(User.t(), changeset)

  @callback delete_session_token(UserToken.t()) :: Result.t(UserToken.t(), changeset)

  @callback fetch_user_by_cpf_and_password(binary, binary) :: Result.t(User.t(), :not_found)
  @callback fetch_user_by_email_and_password(binary, binary) :: Result.t(User.t(), :not_found)
  @callback fetch_user_by_reset_password_token(binary) :: Result.t(User.t(), :not_found)
  @callback fetch_user_by_session_token(binary) :: Result.t(User.t(), :not_found)

  @callback generate_email_token(User.t(), binary) :: Result.t(UserToken.t(), changeset)
  @callback generate_session_token(User.t()) :: Result.t(UserToken.t(), changeset)

  @callback update_user_password(User.t(), binary, map) :: Result.t(Usert.t(), changeset)
  @callback reset_user_password(User.t(), map) :: Result.t(User.t(), changeset)
end
