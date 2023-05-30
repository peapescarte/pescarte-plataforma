defmodule Pescarte.Domains.Accounts.IManageRepository do
  alias Monads.Result
  alias Pescarte.Domains.Accounts.Models.User

  @callback fetch_user(integer) :: Result.t(User.t(), :not_found)
  @callback fetch_user_by_cpf(binary) :: Result.t(User.t(), :not_found)
  @callback fetch_user_by_email(binary) :: Result.t(User.t(), :not_found)
  @callback fetch_user_by_token(binary, binary, integer) :: Result.t(User.t(), :not_found)
end
