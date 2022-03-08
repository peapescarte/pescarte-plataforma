defmodule Fuschia.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Fuschia.Common.Database

  alias Fuschia.Repo

  alias Fuschia.Accounts.Logic.User, as: UserLogic
  alias Fuschia.Accounts.Logic.UserToken, as: UserTokenLogic
  alias Fuschia.Accounts.Models.{AuthLog, User, UserToken}
  alias Fuschia.Accounts.Queries
  alias Fuschia.Accounts.Queries.User, as: UserQueries
  alias Fuschia.Accounts.Queries.UserToken, as: UserTokenQueries
  alias Fuschia.Accounts.UserNotifier
  alias Fuschia.Database

  ## Database getters

  @doc """
  Obtém um usuário a partir de um email

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    email =
      email
      |> String.downcase()
      |> String.trim()

    email
    |> UserQueries.get_by_email_query()
    |> Database.one(UserQueries.relationships())
  end

  @doc """
  Obtém um usuário a partir do email e senha

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = get_user_by_email(email)
    if UserLogic.valid_password?(user, password), do: user
  end

  @doc """
  Obtém a listagem de usuários

  ## Examples

      iex> list_user()
      [%User{}]

      iex> list()
      []

  """
  def list_user do
    with_queries_mod(&list_entity/2, [User])
  end

  @doc """
  Verifica se um suário existe dado um CPF

  ## Examples

      iex> user_exist?("999.999.999-99")
      true

      iex> user_exists?("")
      false

  """
  def user_exists?(cpf) do
    cpf
    |> Queries.User.exist_query()
    |> Fuschia.Database.exists?()
  end

  @doc """
  Obtém apenas um usuário

  ## Examples

      iex> get_user("999.999.999-99")
      %User{}

      iex> get_user("")
      nil

  """
  def get_user(cpf) do
    UserLogic.put_permissions(with_queries_mod(&get_entity/3, [User, cpf]))
  end

  @doc """
  Obtém apenas um usuário pelo id

  ## Examples

      iex> get_user_by_id("JY85XgrT6NYAcaAYhXMQq")
      %User{}

      iex> get_user_by_id("")
      nil

  """
  def get_user_by_id(id) do
    UserLogic.put_permissions(with_queries_mod(&get_entity_by/3, [User, [id: id]]))
  end

  ## User registration

  @spec create_auth_log(map) :: :ok
  def create_auth_log(attrs) do
    %AuthLog{}
    |> AuthLog.changeset(attrs)
    |> Database.insert()

    :ok
  end

  @spec create_auth_log(String.t(), String.t(), User.t()) :: :ok
  def create_auth_log(ip, user_agent, user) do
    user_cpf = Map.get(user, :cpf) || Map.get(user, "cpf")
    create_auth_log(%{"ip" => ip, "user_agent" => user_agent, "user_cpf" => user_cpf})
  end

  @doc """
  Cria um usuário admin

  ## Examples

      iex> create(valid_attrs)
      {:ok, %User{}}

      iex> create(invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    with_queries_mod(&create_and_preload/3, [User, attrs], change_fun: &User.admin_changeset/2)
  end

  @doc """
  Cadastra um novo usuário

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    with_queries_mod(&create_and_preload/3, [User, attrs],
      change_fun: &User.registration_changeset/2
    )
  end

  @doc """
  Retorna um `%Ecto.Changeset{}` para acompanhar as mudanças
  de um usuário.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Retorna um `%Ecto.Changeset{}` para mudar o email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  @doc """
  Emula a atualizaçõa do email de um usuário porém não insere
  no banco de dados.

  ## Examples

    iex> apply_user_email(user, "valid password", %{email: ...})
    {:ok, %User{}}

    iex> apply_user_email(user, "invalid password", %{email: ...})
    {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    with %Ecto.Changeset{valid?: true, params: contact} <-
           User.email_changeset(user, attrs),
         %Ecto.Changeset{valid?: true} = user <- User.update_changeset(user, %{contato: contact}) do
      user
      |> UserLogic.validate_current_password(password)
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

    with {:ok, query} <- UserTokenQueries.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Database.one(query),
         {:ok, _} <- Database.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    with %Ecto.Changeset{valid?: true, params: contact} <-
           User.email_changeset(user, %{email: email}),
         %Ecto.Changeset{valid?: true} = changeset <-
           user |> User.update_changeset(%{contato: contact}) |> User.confirm_changeset() do
      Ecto.Multi.new()
      |> Ecto.Multi.update(:user, changeset)
      |> Ecto.Multi.delete_all(:tokens, UserTokenQueries.user_and_contexts_query(user, [context]))
    end
  end

  @doc """
  Entrega o email para atualização do email de um usuário.

  ## Examples

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} =
      UserTokenLogic.build_email_token(user, "change:#{current_email}")

    {:ok, _} = Database.insert(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Retorna um `%Ecto.Changeset{}` para troca de senha.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Atualiza a senha de um usuário

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> UserLogic.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserTokenQueries.user_and_contexts_query(user, :all))
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
    {token, user_token} = UserTokenLogic.build_session_token(user)
    {:ok, _} = Database.insert(user_token)
    token
  end

  @doc """
  Obtém um usuário dado um token de sessão.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserTokenQueries.verify_session_token_query(token)

    query
    |> Database.one()
    |> Database.preload_all(UserQueries.relationships())
  end

  @doc """
  Deleta um token registrato dado um contexto.
  """
  def delete_session_token(token) do
    Database.delete_all(UserTokenQueries.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Envia o email para confirmação de email do usuário.

  ## Examples

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
      {encoded_token, user_token} = UserTokenLogic.build_email_token(user, "confirm")
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
    with {:ok, query} <- UserTokenQueries.verify_email_token_query(token, "confirm"),
         %User{} = user <- Database.one(query),
         {:ok, %{user: user}} <- Database.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserTokenQueries.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Entrega o email de recuperação de senha para um usuário.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserTokenLogic.build_email_token(user, "reset_password")
    {:ok, _} = Database.insert(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Obtém um usuário dado um token de recuperação de senha.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserTokenQueries.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Database.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Reseta a senha de um usuário.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserTokenQueries.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  defp with_queries_mod(fun, initial_args, opts \\ []) do
    # credo:disable-for-next-line Credo.Check.Refactor.AppendSingleItem
    apply(fun, initial_args ++ [[queries_mod: Queries] ++ opts])
  end
end
