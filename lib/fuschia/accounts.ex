defmodule Fuschia.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Fuschia.Repo

  alias Fuschia.Accounts.{User, UserToken, UserNotifier}

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

    query()
    |> where([u, contato], fragment("lower(?)", contato.email) == ^email)
    |> where([u], u.ativo? == true)
    |> order_by([u], desc: u.created_at)
    |> limit(1)
    |> preload_all()
    |> Repo.one()
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
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Obtém a listagem de usuários

  ## Examples

      iex> list()
      [%User{}]

      iex> list()
      []

  """
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @doc """
  Verifica se um suário existe dado um CPF

  ## Examples

      iex> exist?("999.999.999-99")
      true

      iex> exists?("")
      false

  """
  def exists?(cpf) do
    User
    |> where([u], u.cpf == ^cpf)
    |> Repo.exists?()
  end

  @doc """
  Obtém apenas um usuário

  ## Examples

      iex> get("999.999.999-99")
      %User{}

      iex> get("")
      nil

  """
  def get(cpf) do
    query()
    |> preload_all()
    |> Repo.get(cpf)
    |> put_permissions()
  end

  @doc """
  Obtém apenas um usuário pelo id

  ## Examples

      iex> get("JY85XgrT6NYAcaAYhXMQq")
      %User{}

      iex> get("")
      nil

  """
  def get_by_id(id) do
    query()
    |> preload_all()
    |> Repo.get_by(id: id)
    |> put_permissions()
  end

  ## User registration

  @doc """
  Cria um usuário admin

  ## Examples

      iex> create(valid_attrs)
      {:ok, %User{}}

      iex> create(invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) do
    with {:ok, user} <-
           %User{}
           |> User.admin_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(user)}
    end
  end

  @doc """
  Cadastra um novo usuário

  ## Examples

      iex> register(%{field: value})
      {:ok, %User{}}

      iex> register(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register(attrs) do
    with {:ok, user} <-
           %User{}
           |> User.registration_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(user)}
    end
  end

  @doc """
  Atualiza um usuário existente

  ## Examples

      iex> update(valid_attrs)
      {:ok, %User{}}

      iex> update(invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def update(cpf, attrs) do
    with %User{} = user <- get(cpf) do
      user
      |> User.changeset(attrs)
      |> Repo.update()
    end
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
      |> User.validate_current_password(password)
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

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
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
      |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
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
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
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
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
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
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Obtém um usuário dado um token de sessão.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deleta um token registrato dado um contexto.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
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
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirma um usuário dado um token.

  Caso o token seja válido o usuário é confirmado
  e o token deletado.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
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
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
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
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
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
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  # Helpers

  def query do
    from u in User,
      left_join: contato in assoc(u, :contato),
      order_by: [desc: u.created_at]
  end

  def preload_all(%Ecto.Query{} = query) do
    Ecto.Query.preload(query, [:contato])
  end

  def preload_all(%User{} = user) do
    Repo.preload(user, [:contato])
  end

  defp put_permissions(%User{} = user) do
    # TODO
    Map.put(user, :permissoes, nil)
  end

  defp put_permissions(nil), do: nil
end
