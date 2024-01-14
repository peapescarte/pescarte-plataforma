defmodule Pescarte.Identidades.Handlers.IManageCredenciaisHandler do
  alias Pescarte.Identidades.Models.Usuario

  @typep changeset :: Ecto.Changeset.t()

  @callback confirm_usuario(binary, NaiveDateTime.t()) :: {:ok, Usuario.t()} | {:error, changeset}

  @callback delete_session_token(binary) :: {:ok, integer} | {:error, :not_found}

  @callback fetch_usuario_by_reset_password_token(binary) ::
              {:ok, Usuario.t()} | {:error, :not_found}
  @callback fetch_usuario_by_session_token(binary) :: {:ok, Usuario.t()} | {:error, :not_found}

  @callback generate_email_token(Usuario.t(), binary) :: {:ok, binary}
  @callback generate_session_token(Usuario.t()) :: {:ok, binary}

  @callback update_usuario_password(Usuario.t(), binary, map) ::
              {:ok, Usuario.t()} | {:error, changeset}
  @callback reset_usuario_password(Usuario.t(), map) :: {:ok, Usuario.t()} | {:error, changeset}
end
