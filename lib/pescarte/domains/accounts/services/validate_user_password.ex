defmodule Pescarte.Domains.Accounts.Services.ValidateUserPassword do
  alias Pescarte.Domains.Accounts.Models.User

  @doc """
  Verifica a senha.
  Se não houver usuário ou o usuário não tiver uma senha, chamamos
  `Bcrypt.no_user_verify/0` para evitar ataques de tempo.
  """
  @spec valid_password?(User.t(), binary) :: boolean
  def valid_password?(%User{hash_senha: password_hash}, password)
      when is_binary(password_hash) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, password_hash)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Valida a senha atual, caso contrário adiciona erro ao Changeset
  """
  @spec validate_current_password(Ecto.Changeset.t(), binary) :: Ecto.Changeset.t()
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      Ecto.Changeset.add_error(changeset, :current_password, "is not valid")
    end
  end
end
