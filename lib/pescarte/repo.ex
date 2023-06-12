defmodule Pescarte.Repo do
  use Ecto.Repo,
    otp_app: :pescarte,
    adapter: Ecto.Adapters.Postgres

  @opaque id :: binary | integer

  @doc """
  Busca um registro no banco de dados a partir de um id.
  """
  @spec fetch(Ecto.Queryable.t(), id) :: {:ok, term} | {:error, :not_found}
  def fetch(queryable, id) do
    if result = get(queryable, id) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca e retorna apenas a primeira entrada de um registro no banco de dados.
  """
  @spec fetch_one(Ecto.Queryable.t()) :: {:ok, term} | {:error, :not_found}
  def fetch_one(queryable) do
    if result = one(queryable) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Busca um registro no banco de dados a partir de um campos específico.
  """
  @spec fetch_by(Ecto.Queryable.t(), keyword) :: {:ok, term} | {:error, :not_found}
  def fetch_by(queryable, params) do
    if result = get_by(queryable, params) do
      {:ok, result}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Cria uma transação no banco, aplicando a função passada por argumento.
  Caso ocorra um erro, a transação é revertida e nenhuma modificação é realizada.
  """
  @spec transact((... -> term), keyword) :: {:ok, term} | {:error, Ecto.Changeset.t()}
  def transact(fun, opts \\ []) do
    require Logger

    transaction(
      fn ->
        case fun.() do
          {:ok, term} ->
            term

          {:error, reason} ->
            Logger.error("Erro no Repositório: #{inspect(reason)}")
            rollback(reason)
        end
      end,
      opts
    )
  end
end
