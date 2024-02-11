defmodule Pescarte.Identidades.Handlers.CredenciaisHandler do
  import Pescarte.Identidades.Services.ValidaSenhaUsuario

  alias Ecto.Multi
  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Handlers.IManageCredenciaisHandler
  alias Pescarte.Identidades.Models.Token
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.Identidades.Repository

  @behaviour IManageCredenciaisHandler

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
  def confirm_usuario(token, now) do
    with {:ok, decoded} <- Base.url_decode64(token),
         hashed_token = :crypto.hash(@hash_algorithm, decoded),
         {:ok, user} <-
           Repository.fetch_usuario_by_token(hashed_token, "confirm", @confirm_validity_in_days) do
      changeset = Usuario.confirm_changeset(user, now)
      token_query = Token.user_and_contexts_query(user, ["confirm"])

      Multi.new()
      |> Multi.update(:user, changeset)
      |> Multi.delete_all(:tokens, token_query)
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

  @impl true
  def delete_session_token(user_token) do
    with {:ok, user} <- fetch_usuario_by_session_token(user_token),
         %Ecto.Query{} = query <- Token.user_and_contexts_query(user, :all),
         {integer, nil} <- Repo.delete_all(query) do
      {:ok, integer}
    else
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Busca um usuário a partir de um token de recuperação de senha.
  """
  @impl true
  def fetch_usuario_by_reset_password_token(token) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded)

        Repository.fetch_usuario_by_token(
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
  def fetch_usuario_by_session_token(token) do
    Repository.fetch_usuario_by_token(token, "session", @session_validity_in_days)
  end

  @doc """
  Cria um token e seu hash para ser entregue no email do usuário.
  """
  @impl true
  def generate_email_token(%Usuario{} = user, context)
      when context in ~w(confirm reset_password) do
    token = :crypto.strong_rand_bytes(@login_token_rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    attrs = %{
      token: hashed_token,
      contexto: context,
      usuario_id: user.id,
      enviado_para: user.contato.email_principal
    }

    {:ok, _user_token} = Repo.insert(Token.changeset(attrs))

    {:ok, Base.url_encode64(token, padding: false)}
  end

  @doc """
  Gera um novo token de login/sessão para um usuário.
  """
  @impl true
  def generate_session_token(%Usuario{id: user_id}) do
    token = :crypto.strong_rand_bytes(@login_token_rand_size)
    attrs = %{token: token, contexto: "session", usuario_id: user_id}
    {:ok, _user_token} = Repo.insert(Token.changeset(attrs))

    {:ok, token}
  end

  @doc """
  Atualiza a senha de um usuário

  ## Exemplos

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %Usuario{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def update_usuario_password(%Usuario{} = user, password, attrs) do
    changeset =
      user
      |> Usuario.password_changeset(attrs)
      |> validate_current_password(password)

    token_query = Token.user_and_contexts_query(user, :all)

    Multi.new()
    |> Multi.update(:user, changeset)
    |> Multi.delete_all(:tokens, token_query)
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
      {:ok, %Usuario{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  @impl true
  def reset_usuario_password(%Usuario{} = user, attrs) do
    Multi.new()
    |> Multi.update(:user, Usuario.password_changeset(user, attrs))
    |> Multi.delete_all(:tokens, Token.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
