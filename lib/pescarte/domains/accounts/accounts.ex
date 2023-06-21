defmodule Pescarte.Domains.Accounts do
  @moduledoc false

  import Pescarte.Domains.Accounts.Services.ValidateUserPassword

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
  @session_validity_in_days 60

  @doc """
  Confirma um usuário com base em um token de confirmação.
  Caso o token seja válido, o usuário é confirmado e o token deletado.
  """
  @impl true
  def confirm_user(token, now) do
    with {:ok, decoded} <- Base.url_decode64(token),
         hashed_token = :crypto.hash(@hash_algorithm, decoded),
         {:ok, user} <-
           Repository.fetch_user_by_token(hashed_token, "confirm", @confirm_validity_in_days) do
      changeset = User.confirm_changeset(user, now)
      token_query = UserToken.user_and_contexts_query(user, ["confirm"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(:user, changeset)
      |> Ecto.Multi.delete_all(:tokens, token_query)
      |> Repo.transaction()
      |> case do
        {:ok, %{user: user}} -> {:ok, user}
        {:error, :user, changeset, _} -> {:error, changeset}
      end
    else
      :error -> {:error, :invalid_token}
      err -> err
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
  Cria um usuário do tipo `:pesquisador`.
  """
  @impl true
  def create_user_pesquisador(attrs) do
    create_user(attrs, :pesquisador)
  end

  defp create_user(attrs, tipo) when tipo in ~w(pesquisador admin)a do
    with {:ok, changeset} <- attrs |> Map.put(:tipo, tipo) |> User.changeset() do
      changeset
      |> User.password_changeset(attrs)
      |> Repo.insert()
    end
  end

  defp create_user(attrs, tipo) do
    with {:ok, changeset} <- attrs |> Map.put(:tipo, tipo) |> User.changeset() do
      Repo.insert(changeset)
    end
  end

  @doc """
  Delete um `UserToken`.
  """
  @impl true
  def delete_session_token(user_token) do
    with {:ok, user} <- fetch_user_by_session_token(user_token) do
      user
      |> UserToken.user_and_contexts_query(:all)
      |> Repo.delete_all()
    end
  end

  @impl true
  def fetch_user_by_id(id) do
    Repo.fetch(User, id)
  end

  @impl true
  def fetch_user_by_id_publico(id) do
    Repo.fetch_by(User, id_publico: id)
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
    with {:ok, user} <- Repository.fetch_user_by_cpf(cpf) do
      if valid_password?(user, pass) do
        {:ok, user}
      else
        {:error, :invalid_password}
      end
    end
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
    with {:ok, user} <- Repository.fetch_user_by_email(email) do
      if valid_password?(user, pass) do
        {:ok, user}
      else
        {:error, :invalid_password}
      end
    end
  end

  @doc """
  Busca um usuário a partir de um token de recuperação de senha.
  """
  @impl true
  def fetch_user_by_reset_password_token(token) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded)

        Repository.fetch_user_by_token(
          hashed_token,
          "reset_password",
          @reset_password_validity_in_days
        )

      :error ->
        {:error, :invalid_token}
    end
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
      when context in ~w(confirm reset_password) do
    token = :crypto.strong_rand_bytes(@login_token_rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    attrs = %{
      token: hashed_token,
      contexto: context,
      usuario_id: user.id,
      enviado_para: user.contato.email_principal
    }

    with {:ok, changeset} <- UserToken.changeset(attrs),
         {:ok, _user_token} <- Repo.insert(changeset) do
      {:ok, Base.url_encode64(token, padding: false)}
    end
  end

  @doc """
  Gera um novo token de login/sessão para um usuário.
  """
  @impl true
  def generate_session_token(%User{id: user_id}) do
    token = :crypto.strong_rand_bytes(@login_token_rand_size)
    attrs = %{token: token, contexto: "session", usuario_id: user_id}

    with {:ok, changeset} <- UserToken.changeset(attrs),
         {:ok, _user_token} <- Repo.insert(changeset) do
      {:ok, token}
    end
  end

  @impl true
  defdelegate list_user, to: Repository

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
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
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
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
