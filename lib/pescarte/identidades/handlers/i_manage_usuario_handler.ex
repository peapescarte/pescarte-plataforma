defmodule Pescarte.Identidades.Handlers.IManageUsuarioHandler do
  alias Pescarte.Database
  alias Pescarte.Identidades.Models.Usuario

  @typep changeset :: Ecto.Changeset.t()

  @callback build_usuario_name(Usuario.t()) :: String.t()
  @callback create_usuario_admin(map) :: {:ok, Usuario.t()} | {:error, changeset}
  @callback create_usuario_pesquisador(map) :: {:ok, Usuario.t()} | {:error, changeset}

  @callback fetch_usuario_by_id_publico(Database.id()) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_cpf_and_password(binary, binary) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_email_and_password(binary, binary) ::
              {:ok, Usuario.t()} | {:error, :not_found}

  @callback list_usuario :: list(Usuario.t())
end
