defmodule Pescarte.Domains.Accounts.IManageRepository do
  alias Pescarte.Domains.Accounts.Models.User

  @callback fetch_user(integer) :: {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_id_publico(binary) :: {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_cpf(binary) :: {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_email(binary) :: {:ok, User.t()} | {:error, :not_found}
  @callback fetch_user_by_token(binary, binary, integer) :: {:ok, User.t()} | {:error, :not_found}

  @callback list_user :: list(User.t())
end
