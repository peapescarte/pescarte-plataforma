defmodule Fuschia.Accounts.Logic.UserLogic do
  @moduledoc false

  import Ecto.Changeset, only: [add_error: 3]

  alias Fuschia.Accounts.Models.UserModel

  @doc """
  Verifica a senha.
  Se não houver usuário ou o usuário não tiver uma senha, chamamos
  `Bcrypt.no_user_verify/0` para evitar ataques de tempo.
  """
  def valid_password?(%UserModel{password_hash: password_hash}, password)
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
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def put_permissions(%UserModel{} = user) do
    # TODO
    Map.put(user, :permissoes, nil)
  end

  def put_permissions(nil), do: nil
end
