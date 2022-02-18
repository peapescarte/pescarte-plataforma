defmodule Fuschia.Context.Users do
  @moduledoc """
  Public Fuschia Users API
  """

  import Ecto.Query

  alias Fuschia.Context.UserTokens
  alias Fuschia.Entities.{Contato, User, UserToken}
  alias Fuschia.Repo

  @type user :: User.t()
  @type query :: Ecto.Query.t()
  @type changeset :: Ecto.Changeset.t()

  @spec list :: [user]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: user | nil
  def one(cpf) do
    query()
    |> preload_all()
    |> Repo.get(cpf)
    |> put_permissions()
    |> put_is_admin()
  end

  @spec one_by_cpf(String.t()) :: user | nil
  def one_by_cpf(cpf) do
    cpf = String.trim(cpf)

    query()
    |> preload_all()
    |> Repo.get_by(cpf: cpf)
  end

  @spec one_by_email(String.t()) :: user | nil
  def one_by_email(email) do
    email =
      email
      |> String.downcase()
      |> String.trim()

    query()
    |> where([u, contato], fragment("lower(?)", contato.email) == ^email)
    |> where([u], u.ativo == true)
    |> order_by([u], desc: u.created_at)
    |> limit(1)
    |> preload_all()
    |> Repo.one()
  end

  @spec one_with_permissions(String.t()) :: user | nil
  def one_with_permissions(cpf) do
    cpf
    |> one_by_cpf()
    |> put_permissions()
    |> put_is_admin()
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> one_by_reset_password_token("validtoken")
      %User{}

      iex> one_by_reset_password_token("invalidtoken")
      nil

  """
  @spec one_by_reset_password_token(String.t()) :: user | nil
  def one_by_reset_password_token(token) do
    with {:ok, query} <- UserTokens.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    end
  end

  @spec create(map) :: {:ok, user} | {:error, changeset}
  def create(attrs) do
    with {:ok, user} <-
           %User{}
           |> User.admin_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(user)}
    end
  end

  @spec update(String.t(), map) :: {:ok, user} | {:error, changeset}
  def update(cpf, attrs) do
    with %User{} = user <- one(cpf) do
      user
      |> User.changeset(attrs)
      |> Repo.update()
    end
  end

  @spec register(map) :: {:ok, user} | {:error, changeset}
  def register(attrs) do
    with {:ok, user} <-
           %User{}
           |> User.registration_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(user)}
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  @spec reset_password(String.t(), map) :: {:ok, user} | {:error, changeset}
  def reset_password(cpf, attrs) do
    with %User{} = user <- one(cpf),
         {:ok, %{user: reseted}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
           |> Ecto.Multi.delete_all(:tokens, UserTokens.user_and_contexts_query(user, :all))
           |> Repo.transaction() do
      {:ok, reseted}
    else
      {:error, :user, changeset, _e} ->
        {:error, changeset}
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  @spec confirm_user(String.t()) :: {:ok, user} | :error
  def confirm_user(token) do
    with {:ok, query} <- UserTokens.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_multi(user)) do
      {:ok, user}
    else
      _err -> :error
    end
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  @spec update_email(String.t(), String.t()) :: :ok | :error
  def update_email(cpf, token) do
    with %User{} = user <- one(cpf),
         context <- "change:#{user.contato.email}",
         {:ok, query} <- UserTokens.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(email_multi(user, email, context)) do
      :ok
    else
      _err -> :error
    end
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_password(String.t(), String.t(), map) ::
          {:ok, user} | {:error, changeset}
  def update_password(cpf, password, attrs) do
    with %User{} = user <- one(cpf),
         changeset <-
           user
           |> User.password_changeset(attrs)
           |> User.validate_current_password(password),
         {:ok, %{user: user}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.update(:user, changeset)
           |> Ecto.Multi.delete_all(:tokens, UserTokens.user_and_contexts_query(user, :all))
           |> Repo.transaction() do
      {:ok, user}
    else
      {:error, :user, changeset, _e} ->
        {:error, changeset}
    end
  end

  @spec exists?(String.t()) :: boolean
  def exists?(cpf) do
    User
    |> where([u], u.cpf == ^cpf)
    |> Repo.exists?()
  end

  @spec query :: query
  def query do
    from u in User,
      left_join: contato in assoc(u, :contato),
      order_by: [desc: u.created_at]
  end

  @spec preload_all(query) :: query
  def preload_all(%Ecto.Query{} = query) do
    Ecto.Query.preload(query, [:contato])
  end

  @spec preload_all(user) :: user
  def preload_all(%User{} = user) do
    Repo.preload(user, [:contato])
  end

  defp put_is_admin(%User{perfil: "admin"} = user) do
    Map.put(user, :is_admin, true)
  end

  defp put_is_admin(%User{} = user) do
    Map.put(user, :is_admin, false)
  end

  defp put_is_admin(nil), do: nil

  defp put_permissions(%User{} = user) do
    # TODO
    Map.put(user, :permissoes, nil)
  end

  defp put_permissions(nil), do: nil

  defp confirm_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(
      :tokens,
      UserTokens.user_and_contexts_query(user, ["confirm"])
    )
  end

  defp email_multi(user, email, context) do
    changeset = user |> Contato.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserTokens.user_and_contexts_query(user, [context]))
  end
end
