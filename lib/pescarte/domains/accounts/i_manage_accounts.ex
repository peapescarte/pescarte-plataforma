defmodule Pescarte.Domains.Accounts.IManageAccounts do
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Models.UserToken

  @typep changeset :: Ecto.Changeset.t()

  @callback confirm_user(binary, NaiveDateTime.t()) :: {:ok, User.t()} | {:error, changeset}

  @callback create_user_admin(map) :: {:ok, User.t()} | {:error, changeset}
  @callback create_user_pesquisador(map) :: {:ok, User.t()} | {:error, changeset}

  @callback delete_session_token(UserToken.t()) :: {:ok, UserToken.t()} | {:error, changeset}

  @callback fetch_user(Pescarte.Repo.id()) :: {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_cpf_and_password(binary, binary) ::
              {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_email_and_password(binary, binary) ::
              {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_reset_password_token(binary) :: {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_session_token(binary) :: {:ok, User.t()} | {:error, :not_found}

  @callback generate_email_token(User.t(), binary) :: {:ok, UserToken.t()} | {:error, changeset}
  @callback generate_session_token(User.t()) :: {:ok, UserToken.t()} | {:error, changeset}

  @callback list_user :: list(User.t())

  @callback update_user_password(User.t(), binary, map) :: {:ok, User.t()} | {:error, changeset}
  @callback reset_user_password(User.t(), map) :: {:ok, User.t()} | {:error, changeset}
end
