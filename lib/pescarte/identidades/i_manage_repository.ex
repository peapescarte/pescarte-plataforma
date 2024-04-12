defmodule Pescarte.Identidades.IManageRepository do
  alias Pescarte.Identidades.Models.Usuario

  @callback fetch_usuario_by_cpf(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_email(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_token(binary, binary, integer) ::
              {:ok, Usuario.t()} | {:error, :not_found}

  @callback list_usuario :: list(Usuario.t())

  @callback insert_usuario(Ecto.Changeset.t()) ::
              {:ok, Usuario.t()} | {:error, Ecto.Changeset.t()}
end
