defmodule Pescarte.Domains.Accounts.IManageAccounts do
  alias Pescarte.Domains.Accounts.Models.UserToken
  alias Pescarte.Domains.Accounts.Models.Usuario

  @typep changeset :: Ecto.Changeset.t()

  @callback confirm_user(binary, NaiveDateTime.t()) :: {:ok, Usuario.t()} | {:error, changeset}

  @callback create_user_admin(map) :: {:ok, Usuario.t()} | {:error, changeset}
  @callback create_user_pesquisador(map) :: {:ok, Usuario.t()} | {:error, changeset}

  @callback delete_session_token(UserToken.t()) :: {:ok, integer} | {:error, :not_found}

  @callback fetch_user_by_id_publico(Pescarte.Repo.id()) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_user_by_cpf_and_password(binary, binary) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_user_by_email_and_password(binary, binary) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_user_by_reset_password_token(binary) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_user_by_session_token(binary) :: {:ok, Usuario.t()} | {:error, :not_found}

  @callback generate_email_token(Usuario.t(), binary) :: {:ok, binary}
  @callback generate_session_token(Usuario.t()) :: {:ok, binary}

  @callback list_user :: list(Usuario.t())

  @callback update_user_password(Usuario.t(), binary, map) ::
              {:ok, Usuario.t()} | {:error, changeset}
  @callback reset_user_password(Usuario.t(), map) :: {:ok, Usuario.t()} | {:error, changeset}
end
