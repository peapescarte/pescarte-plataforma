defmodule Identidades.IManageRepository do
  alias Identidades.Models.Usuario

  @callback fetch_usuario_by_cpf(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_email(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_id_publico(binary) :: {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_token(binary, binary, integer) ::
              {:ok, Usuario.t()} | {:error, :not_found}

  @callback list_usuario :: list(Usuario.t())

  @callback insert_usuario(Ecto.Changeset.t()) ::
              {:ok, Usuario.t()} | {:error, Ecto.Changeset.t()}
end
