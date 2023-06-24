defmodule Database do
  @type id :: binary | integer
  @type fetch_result :: {:ok, struct} | {:error, :not_found}

  @doc """
  Busca um registro no banco de dados a partir de um id.
  """
  @spec fetch(Ecto.Repo.t(), Ecto.Queryable.t(), Database.id()) :: Database.fetch_result()
  def fetch(repo, queryable, id) do
    if result = repo.get(queryable, id) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca e retorna apenas a primeira entrada de um registro no banco de dados.
  """
  @spec fetch_one(Ecto.Repo.t(), Ecto.Queryable.t()) :: Database.fetch_result()
  def fetch_one(repo, queryable) do
    if result = repo.one(queryable) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca um registro no banco de dados a partir de um campos específico.
  """
  @spec fetch_by(Ecto.Repo.t(), Ecto.Queryable.t(), keyword) :: Database.fetch_result()
  def fetch_by(repo, queryable, params) do
    if result = repo.get_by(queryable, params) do
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

      def write_repo, do: Application.get_env(:database, :write_repo)
      def read_repo, do: Application.get_env(:database, :read_repo)
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
