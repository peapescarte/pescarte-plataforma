defmodule Pescarte.Domains.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Pescarte.Domains.Accounts.UserNotifier

  alias Pescarte.Domains.Accounts.IO.UserRepo
  alias Pescarte.Domains.Accounts.IO.UserTokenRepo
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Models.UserToken
  alias Pescarte.Domains.Accounts.Services
  alias Pescarte.Database

  defdelegate list_user, to: Services.GetUser, as: :process

  defdelegate get_user(params), to: Services.GetUser, as: :process

  def get_user_by_cpf_and_password(cpf, pass) do
    Services.GetUser.process(cpf: cpf, password: pass)
  end

  @doc """
  Obtém um usuário a partir de um email

  ## Exemplos

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) do
    Services.GetUser.process(email: email)
  end

  @doc """
  Obtém um usuário a partir do email e senha

  ## Exemplos

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, pass) do
    Services.GetUser.process(email: email, password: pass)
  end

  @doc """
  Obtém apenas um usuário

  ## Exemplos

      iex> get_user("999.999.999-99")
      %User{}

      iex> get_user("")
      nil

  """
  def fetch_user(cpf) do
    Services.GetUser.process(cpf: cpf)
  end

  @doc """
  Obtém apenas um usuário pelo id

  ## Exemplos

      iex> get_user_by_id("JY85XgrT6NYAcaAYhXMQq")
      %User{}

      iex> get_user_by_id("")
      nil

  """
  def get_user_by_id(id) do
    Services.GetUser.process(id: id)
  end

  def insert_user(params) do
    Services.CreateUser.process(params, :admin)
  end

  def register_user(params) do
    Services.CreateUser.process(params)
  end

  @doc """
  Retorna um `%Ecto.Changeset{}` para acompanhar as mudanças
  de um usuário.

  ## Exemplos

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(attrs \\ %{}) do
    attrs
    |> UserRepo.changeset()
    |> UserRepo.password_changeset(attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Retorna um `%Ecto.Changeset{}` para mudar o email.

  ## Exemplos

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    UserRepo.email_changeset(user, attrs)
  end

  @doc """
  Emula a atualizaçõa do email de um usuário porém não insere
  no banco de dados.

  ## Exemplos

    iex> apply_user_email(user, "valid password", %{email: ...})
    {:ok, %User{}}

    iex> apply_user_email(user, "invalid password", %{email: ...})
    {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    with %Ecto.Changeset{valid?: true, params: contato} <-
           UserRepo.email_changeset(user, attrs),
         %Ecto.Changeset{valid?: true} = user <-
           user
           |> Ecto.Changeset.cast(%{contato: contato}, [])
           |> Ecto.Changeset.cast_assoc(user, :contato) do
      user
      |> Services.UserFields.validate_current_password(password)
      |> Ecto.Changeset.apply_action(:update)
    else
      changeset -> {:error, changeset}
    end
  end

  @doc """
  Atualiza o email de um susuário dado um token.

  Se o token for válido, o email é atualizado e o token deletado.
  O campo `confirmed_at` também é atualizado para a data atual
  """
  def update_user_email(user, token) do
    context = "change:#{user.contato.email}"

    with {:ok, query} <- UserTokenRepo.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Database.one(query),
         {:ok, _} <- Database.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    with %Ecto.Changeset{valid?: true, params: contato} <-
           UserRepo.email_changeset(user, %{email: email}),
         %Ecto.Changeset{valid?: true} = changeset <-
           user
           |> Ecto.Changeset.cast(%{contato: contato}, [])
           |> Ecto.Changeset.cast_assoc(:contato)
           |> UserRepo.confirm_changeset() do
      meta = %{meta: %{type: "user_update_email"}}

      Ecto.Multi.new()
      |> Carbonite.Multi.insert_transaction(meta)
      |> Ecto.Multi.update(:user, changeset)
      |> Ecto.Multi.delete_all(:tokens, UserTokenRepo.user_and_contexts_query(user, [context]))
    end
  end

  @doc """
  Entrega o email para atualização do email de um usuário.

  ## Exemplos

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} =
      Services.BuildUserToken.build_email_token(user, "change:#{current_email}")

    {:ok, _} = Database.insert(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Retorna um `%Ecto.Changeset{}` para troca de senha.

  ## Exemplos

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    UserRepo.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Atualiza a senha de um usuário

  ## Exemplos

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> UserRepo.password_changeset(attrs)
      |> Services.UserFields.validate_current_password(password)

    meta = %{meta: %{type: "user_update_password"}}

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserTokenRepo.user_and_contexts_query(user, :all))
    |> Database.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Gera um token de sessão.
  """
  def generate_user_session_token(user) do
    {token, user_token} = Services.BuildUserToken.build_session_token(user)
    {:ok, _} = Database.insert(user_token)
    token
  end

  @doc """
  Obtém um usuário dado um token de sessão.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserTokenRepo.verify_session_token_query(token)

    query
    |> Database.one()
    |> Database.preload([:contato, :pesquisador])
  end

  @doc """
  Deleta um token registrato dado um contexto.
  """
  def delete_session_token(token) do
    token
    |> UserTokenRepo.token_and_context_query("session")
    |> Database.delete_all()

    :ok
  end

  ## Confirmation

  @doc """
  Envia o email para confirmação de email do usuário.

  ## Exemplos

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :edit, &1))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = Services.BuildUserToken.build_email_token(user, "confirm")
      {:ok, _} = Database.insert(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirma um usuário dado um token.

  Caso o token seja válido o usuário é confirmado
  e o token deletado.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserTokenRepo.verify_email_token_query(token, "confirm"),
         %User{} = user <- Database.one(query),
         {:ok, %{user: user}} <- Database.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, UserRepo.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserTokenRepo.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Entrega o email de recuperação de senha para um usuário.

  ## Exemplos

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} =
      Services.BuildUserToken.build_email_token(user, "reset_password")

    {:ok, _} = Database.insert(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Obtém um usuário dado um token de recuperação de senha.

  ## Exemplos

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserTokenRepo.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Database.one(query) do
      user
    else
      _ -> nil
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
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, UserRepo.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserTokenRepo.user_and_contexts_query(user, :all))
    |> Database.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
