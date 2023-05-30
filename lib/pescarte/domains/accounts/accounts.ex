defmodule Pescarte.Domains.Accounts do
  # TODO: melhorar documentação
  @moduledoc false

  import Pescarte.Domains.Accounts.Services.ValidateUserPassword

  alias Monads.Result
  alias Pescarte.Domains.Accounts.IManageAccounts
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Models.UserToken
  alias Pescarte.Domains.Accounts.Repository
  alias Pescarte.Repo

  @behaviour IManageAccounts

  @hash_algorithm :sha256
  @login_token_rand_size 32

  # É muito importante manter a expiração do token de redefinição de senha curta,
  # já que alguém com acesso ao e-mail pode assumir a conta.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  @doc """
  Confirma um usuário com base em um token de confirmação.
  Caso o token seja válido, o usuário é confirmado e o token deletado.
  """
  @impl true
  def confirm_user(token, now) do
    with {:ok, decoded} <- Base.url_decode64(token) do
      hashed_token = :crypto.hash(@hash_algorithm, decoded)

      hashed_token
      |> Repository.fetch_user_by_token("confirm", @confirm_validity_in_days)
      |> Result.and_then(fn user ->
        changeset = User.confirm_changeset(user, now)
        token_query = UserToken.user_and_contexts_query(user, ["confirm"])

        Ecto.Multi.new()
        |> Ecto.Multi.update(:user, changeset)
        |> Ecto.Multi.delete_all(:tokens, token_query)
        |> Repo.transaction()
        |> case do
          {:ok, %{user: user}} -> Result.ok(user)
          {:error, :user, changeset, _} -> Result.error(changeset)
        end
      end)
    else
      :error -> Result.error(:invalid_token)
    end
  end

  @doc """
  Cria um usuário do tipo `:admin`.
  """
  @impl true
  def create_user_admin(attrs) do
    create_user(attrs, :admin)
  end

  @doc """
  Cria um usuário do tipo `:avulso`.
  """
  @impl true
  def create_user_avulso(attrs) do
    create_user(attrs, :avulso)
  end

  @doc """
  Cria um usuário do tipo `:pesquisador`.
  """
  @impl true
  def create_user_pesquisador(attrs) do
    create_user(attrs, :pesquisador)
  end

  defp create_user(attrs, tipo) when tipo in ~w(pesquisador admin)a do
    attrs
    |> Map.put(:tipo, tipo)
    |> User.changeset()
    |> Result.map(&User.password_changeset(&1, attrs))
    |> Result.and_then(&Repo.insert/1)
  end

  defp create_user(attrs, tipo) do
    attrs
    |> Map.put(:tipo, tipo)
    |> User.changeset()
    |> Result.and_then(&Repo.insert/1)
  end

  @doc """
  Delete um `UserToken`.
  """
  @impl true
  def delete_session_token(%UserToken{} = user_token) do
    Repo.delete(user_token)
  end

  @doc """
  Busca um registro de `User.t()`, com base no `:cpf`
  e na `:senha`, caso seja válida.

  ## Exemplos

      iex> fetch_user_by_cpf_and_password("12345678910", "123")
      {:ok, %User{}}

      iex> fetch_user_by_cpf_and_password("12345678910", "invalid")
      {:error, :not_found}

      iex> fetch_user_by_cpf_and_password("invalid", "123")
      {:error, :not_found}

  """
  @impl true
  def fetch_user_by_cpf_and_password(cpf, pass) do
    cpf
    |> Repository.fetch_user_by_cpf()
    |> Result.and_then(fn user ->
      user |> valid_password?(pass) |> Result.new(:not_found)
    end)
  end

  @doc """
  Busca um registro de `User.t()`, com base no `:email`
  e na `:senha`, caso seja válida.

  ## Exemplos

      iex> fetch_user_by_email_and_password("foo@example.com", "correct_password")
      {:ok, %User{}}

      iex> fetch_user_by_email_and_password("foo@example.com", "invalid_password")
      {:error, :not_found}

  """
  @impl true
  def fetch_user_by_email_and_password(email, pass) do
    email
    |> Repository.fetch_user_by_email()
    |> Result.and_then(fn user ->
      user |> valid_password?(pass) |> Result.new(:not_found)
    end)
  end

  @doc """
  Busca um usuário a partir de um token de recuperação de senha.
  """
  @impl true
  def fetch_user_by_reset_password_token(token) do
    Repository.fetch_user_by_token(token, "reset_password", @reset_password_validity_in_days)
  end

  @doc """
  Busca um usuária a partir de um token de login/sessão.
  """
  @impl true
  def fetch_user_by_session_token(token) do
    Repository.fetch_user_by_token(token, "session", @session_validity_in_days)
  end

  @doc """
  Cria um token e seu hash para ser entregue no email do usuário.
  """
  @impl true
  def generate_email_token(%User{} = user, context)
      when context in ~w(confirm session reset_password) do
    token = :crypto.strong_rand_bytes(@login_token_rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    %{
      token: hashed_token,
      context: context,
      user_id: user.id,
      enviado_para: user.contato.email_principal
    }
    |> UserToken.changeset()
    |> Result.and_then(&Repo.insert/1)
    |> Result.map(fn _ ->
      Base.url_encode64(token, padding: false)
    end)
  end

  @doc """
  Gera um novo token de login/sessão para um usuário.
  """
  @impl true
  def generate_session_token(%User{id: user_id}) do
    token = :crypto.strong_rand_bytes(@login_token_rand_size)

    %{token: token, context: "session", user_id: user_id}
    |> UserToken.changeset()
    |> Result.and_then(&Repo.insert/1)
  end

  @doc """
  Atualiza a senha de um usuário

  ## Exemplos

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def update_user_password(%User{} = user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> validate_current_password(password)

    token_query = UserToken.user_and_contexts_query(user, :all)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, token_query)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> Result.ok(user)
      {:error, :user, changeset, _} -> Result.error(changeset)
    end
  end

  @doc """
  Reseta a senha de um usuário.

  ## Exemplos

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def reset_user_password(%User{} = user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> Result.ok(user)
      {:error, :user, changeset, _} -> Result.error(changeset)
    end
  end
end
