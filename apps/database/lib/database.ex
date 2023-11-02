defmodule Database do
  @type id :: binary | integer
  @type fetch_result :: {:ok, struct} | {:error, :not_found}

  def config_env, do: Application.get_env(:database, :config_env)

  @migrations_apps ~w(cotacoes identidades modulo_pesquisa catalogo)a

  @spec migrations_paths(atom) :: list(Path.t())
  def migrations_paths(:dev) do
    for app <- @migrations_apps do
      Path.join(["apps", to_string(app), "priv/repo/migrations"])
    end
  end

  def migrations_paths(:release) do
    for app <- @migrations_apps do
      priv_dir = List.to_string(:code.priv_dir(app))
      Path.join(priv_dir, "repo/migrations")
    end
  end

  def migrations_paths(_), do: []

  @doc """
  Busca um registro no banco de dados a partir de um id.
  """
  @spec fetch(Ecto.Queryable.t(), Database.id()) :: Database.fetch_result()
  def fetch(queryable, id) do
    if result = Database.Repo.replica().get(queryable, id) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca e retorna apenas a primeira entrada de um registro no banco de dados.
  """
  @spec fetch_one(Ecto.Queryable.t()) :: Database.fetch_result()
  def fetch_one(queryable) do
    if result = Database.Repo.replica().one(queryable) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca um registro no banco de dados a partir de um campos específico.
  """
  @spec fetch_by(Ecto.Queryable.t(), keyword) :: Database.fetch_result()
  def fetch_by(queryable, params) do
    if result = Database.Repo.replica().get_by(queryable, params) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  def model do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      alias __MODULE__
      @typep changeset :: Ecto.Changeset.t()
      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end

  def repository do
    quote do
      import Ecto.Query
      alias Database.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
