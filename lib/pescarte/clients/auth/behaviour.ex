defmodule Pescarte.Clients.Auth.Behaviour do
  @moduledoc """
  Interface abstrata para implementação de clientes de autenticação e gerenciamento de usuários.
  """

  alias Pescarte.Result

  @type role :: :admin | :pesquisador | :pescador

  @type user_metadata :: %{
          required(:first_name) => String.t(),
          required(:last_name) => String.t(),
          required(:cpf) => String.t(),
          required(:birthdate) => Date.t(),
          required(:user_id) => String.t(),
          optional(:phone) => String.t()
        }

  @type create_user_t :: %{
          required(:email) => String.t(),
          required(:password) => String.t(),
          required(:role) => role,
          required(:app_metadata) => user_metadata
        }

  @type update_user_t :: %{
          required(:email) => String.t(),
          required(:role) => role,
          required(:app_metadata) => user_metadata
        }

  @type user_t :: %{
          required(:id) => String.t(),
          required(:email) => String.t(),
          required(:role) => role,
          required(:app_metadata) => user_metadata
        }

  @type session_t :: %{
          required(:token) => String.t(),
          required(:expires_at) => DateTime.t(),
          required(:user) => user_t
        }

  @type login_t :: %{
          required(:email) => String.t(),
          required(:password) => String.t()
        }

  @doc """
  Cria um usuário no sistema de autenticação.
  """
  @callback create_user(create_user_t) :: Result.t(term, user_t)

  @doc """
  Atualiza os dados de um usuário no sistema de autenticação.
  """
  @callback update_user(id :: String.t(), update_user_t) :: Result.t(term, user_t)

  @doc """
  Remove um usuário do sistema de autenticação.
  """
  @callback delete_user(id :: String.t()) :: Result.t(term, String.t())

  @doc """
  Autentica um usuário no sistema de autenticação.
  """
  @callback authenticate(login_t) :: Result.t(term, session_t)

  @doc """
  Busca um usuário no sistema de autenticação.
  """
  @callback get_user(id :: String.t()) :: Result.t(term, user_t)

  @callback sign_out(token :: String.t, scope :: atom) :: Result.t(term, term)

  @callback resend_confirmation_email(email :: String.t, type :: atom, redirect_to :: String.t) :: Result.t(term, term)

  @optional_callbacks resend_confirmation_email: 3
end
