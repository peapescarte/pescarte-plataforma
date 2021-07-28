defmodule Fuschia.Context.Users do
  @moduledoc """
  Public Fuschia Users API
  """

  import Ecto.Query

  alias Fuschia.Context.UserTokens
  alias Fuschia.Entities.{User, UserToken}
  alias Fuschia.Repo

  @behaviour Fuschia.ContextBehaviour

  @impl true
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @impl true
  def one(id) do
    query()
    |> preload_all()
    |> Repo.get(id)
    |> put_permissions()
    |> put_is_admin()
  end

  @spec one_by_email(String.t()) :: %User{} | nil
  def one_by_email(email) do
    email =
      email
      |> String.downcase()
      |> String.trim()

    query()
    |> where([u], fragment("lower(?)", u.email) == ^email)
    |> where([u], u.ativo == true)
    |> order_by([u], desc: u.created_at)
    |> limit(1)
    |> preload_all()
    |> Repo.one()
  end

  @spec one_with_permissions(String.t()) :: %User{} | nil
  def one_with_permissions(email) do
    email
    |> one_by_email()
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
  @spec one_by_reset_password_token(String.t()) :: %User{} | nil
  def one_by_reset_password_token(token) do
    with {:ok, query} <- UserTokens.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    end
  end

  @impl true
  def create(attrs) do
    with {:ok, user} <-
           %User{}
           |> User.admin_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(user)}
    end
  end

  @impl true
  def update(id, attrs) do
    with %User{} = user <- one(id),
         {:ok, updated} <-
           user
           |> User.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec register(map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
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
  @spec reset_password(integer, map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def reset_password(id, attrs) do
    with %User{} = user <- one(id),
         {:ok, %{user: reseted}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
           |> Ecto.Multi.delete_all(:tokens, UserTokens.user_and_contexts_query(user, :all))
           |> Repo.transaction() do
      {:ok, reseted}
    else
      {:error, :user, changeset, _} ->
        {:error, changeset}
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  @spec confirm_user(String.t()) :: {:ok, %User{}} | :error
  def confirm_user(token) do
    with {:ok, query} <- UserTokens.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  @spec update_email(integer, String.t()) :: :ok | :error
  def update_email(id, token) do
    with %User{} = user <- one(id),
         context <- "change:#{user.email}",
         {:ok, query} <- UserTokens.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
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
  @spec update_password(integer, String.t(), map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def update_password(id, password, attrs) do
    with %User{} = user <- one(id),
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
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  @spec exists?(integer | String.t()) :: boolean
  def exists?(id) do
    User
    |> where([u], u.id == ^id)
    |> Repo.exists?()
  end

  @impl true
  def query do
    from u in User, order_by: [desc: u.id]
  end

  @impl true
  def preload_all(%Ecto.Query{} = query) do
    # TODO
    query
  end

  @impl true
  def preload_all(%User{} = user) do
    # TODO
    user
  end

  defp put_is_admin(%User{perfil: "admin"} = user) do
    Map.put(user, :is_admin, true)
  end

  defp put_is_admin(%User{} = user) do
    Map.put(user, :is_admin, false)
  end

  defp put_permissions(%User{} = user) do
    # TODO
    Map.put(user, :permissoes, nil)
  end

  defp confirm_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(
      :tokens,
      UserTokens.user_and_contexts_query(user, ["confirm"])
    )
  end

  defp email_multi(user, email, context) do
    changeset = user |> User.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserTokens.user_and_contexts_query(user, [context]))
  end
end
