defmodule Fuschia.Context.Users do
  @moduledoc """
  Public Fuschia Users API
  """

  import Ecto.Query

  alias Fuschia.Entities.User
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
    |> where([u], fragment("lower(?)", u.email == ^email))
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
end
