defmodule Pescarte.Database do
  @type id :: binary | integer
  @type fetch_result :: {:ok, struct} | {:error, :not_found}

  @doc """
  Busca um registro no banco de dados a partir de um id.
  """
  @spec fetch(Ecto.Queryable.t(), Pescarte.Database.id()) :: Pescarte.Database.fetch_result()
  def fetch(queryable, id) do
    if result = Pescarte.Database.Repo.replica().get(queryable, id) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca e retorna apenas a primeira entrada de um registro no banco de dados.
  """
  @spec fetch_one(Ecto.Queryable.t()) :: Pescarte.Database.fetch_result()
  def fetch_one(queryable) do
    if result = Pescarte.Database.Repo.replica().one(queryable) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca um registro no banco de dados a partir de um campos específico.
  """
  @spec fetch_by(Ecto.Queryable.t(), keyword) :: Pescarte.Database.fetch_result()
  def fetch_by(queryable, params) do
    if result = Pescarte.Database.Repo.replica().get_by(queryable, params) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end
end
