defmodule Pescarte.Domains.Accounts.IManageRepository do
  alias Pescarte.Domains.Accounts.Models.Usuario

  @callback fetch_user_by_cpf(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_user_by_email(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_user_by_token(binary, binary, integer) ::
              {:ok, Usuario.t()} | {:error, :not_found}

  @callback list_user :: list(Usuario.t())
end
