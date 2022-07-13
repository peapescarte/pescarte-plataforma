defmodule Fuschia.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Fuschia.Repo

  alias Fuschia.Accounts.Logic.User, as: UserLogic
  alias Fuschia.Accounts.Logic.UserToken, as: UserTokenLogic
  alias Fuschia.Accounts.Models.AuthLog
  alias Fuschia.Accounts.Models.User, as: UserModel
  alias Fuschia.Accounts.Models.UserToken, as: UserTokenModel
  alias Fuschia.Accounts.Queries
  alias Fuschia.Accounts.Queries.User, as: UserQueries
  alias Fuschia.Accounts.Queries.UserToken, as: UserTokenQueries
  alias Fuschia.Accounts.UserNotifier
  alias Fuschia.Database

  ## Database getters

  def get_user_by_cpf_and_password(cpf, password) do
    user = get_user(cpf)
    if UserLogic.valid_password?(user, password), do: user
  end

  @doc """
  Obtém um usuário a partir de um email

  ## Exemplos

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

  ## Exemplos

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

  ## Exemplos

      iex> list_user()
      [%User{}]

      iex> list()
      []

  """
  def list_user do
    with_queries_mod(&Database.list_entity/2, [UserModel])
  end

  @doc """
  Verifica se um suário existe dado um CPF

  ## Exemplos

      iex> user_exist?("999.999.999-99")
      true

      iex> user_exists?("")
      false

  """
  def user_exists?(cpf) do
    cpf
    |> UserQueries.exist_query()
    |> Database.exists?()
  end

  @doc """
  Obtém apenas um usuário

  ## Exemplos

      iex> get_user("999.999.999-99")
      %User{}

      iex> get_user("")
      nil

  """
  def get_user(cpf) do
    get_fun = &Database.get_entity/3

    get_fun
    |> with_queries_mod([UserModel, cpf])
    |> UserLogic.put_permissions()
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
    get_fun = &Database.get_entity_by/3

    get_fun
    |> with_queries_mod([UserModel, [id: id]])
    |> UserLogic.put_permissions()
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

  ## Exemplos

      iex> create(valid_attrs)
      {:ok, %User{}}

      iex> create(invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    with_queries_mod(&Database.create_and_preload/3, [UserModel, attrs],
      change_fun: &UserModel.admin_changeset/2
    )
  end

  @doc """
  Cadastra um novo usuário

  ## Exemplos

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    with_queries_mod(&Database.create_and_preload/3, [UserModel, attrs],
      change_fun: &UserModel.registration_changeset/2
    )
  end

  @doc """
  Retorna um `%Ecto.Changeset{}` para acompanhar as mudanças
  de um usuário.

  ## Exemplos

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%UserModel{} = user, attrs \\ %{}) do
    UserModel.registration_changeset(user, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Retorna um `%Ecto.Changeset{}` para mudar o email.

  ## Exemplos

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    UserModel.email_changeset(user, attrs)
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
    with %Ecto.Changeset{valid?: true, params: contact} <-
           UserModel.email_changeset(user, attrs),
         %Ecto.Changeset{valid?: true} = user <-
           UserModel.update_changeset(user, %{contato: contact}) do
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
         %UserTokenModel{sent_to: email} <- Database.one(query),
         {:ok, _} <- Database.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    with %Ecto.Changeset{valid?: true, params: contact} <-
           UserModel.email_changeset(user, %{email: email}),
         %Ecto.Changeset{valid?: true} = changeset <-
           user
           |> UserModel.update_changeset(%{contato: contact})
           |> UserModel.confirm_changeset() do
      meta = %{meta: %{type: "user_update_email"}}

      Ecto.Multi.new()
      |> Carbonite.Multi.insert_transaction(meta)
      |> Ecto.Multi.update(:user, changeset)
      |> Ecto.Multi.delete_all(:tokens, UserTokenQueries.user_and_contexts_query(user, [context]))
    end
  end

  @doc """
  Entrega o email para atualização do email de um usuário.

  ## Exemplos

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%UserModel{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} =
      UserTokenLogic.build_email_token(user, "change:#{current_email}")

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
    UserModel.password_changeset(user, attrs, hash_password: false)
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
      |> UserModel.password_changeset(attrs)
      |> UserLogic.validate_current_password(password)

    meta = %{meta: %{type: "user_update_password"}}

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
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
    token
    |> UserTokenQueries.token_and_context_query("session")
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
  def deliver_user_confirmation_instructions(%UserModel{} = user, confirmation_url_fun)
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
         %UserModel{} = user <- Database.one(query),
         {:ok, %{user: user}} <- Database.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, UserModel.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserTokenQueries.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Entrega o email de recuperação de senha para um usuário.

  ## Exemplos

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%UserModel{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserTokenLogic.build_email_token(user, "reset_password")
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
    with {:ok, query} <- UserTokenQueries.verify_email_token_query(token, "reset_password"),
         %UserModel{} = user <- Database.one(query) do
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
    |> Ecto.Multi.update(:user, UserModel.password_changeset(user, attrs))
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
