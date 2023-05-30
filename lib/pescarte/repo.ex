defmodule Pescarte.Repo do
  use Ecto.Repo,
    otp_app: :pescarte,
    adapter: Ecto.Adapters.Postgres

  alias Monads.Result

  @opaque id :: binary | integer

  @doc """
  Busca um registro no banco de dados a partir de um id.
  """
  @spec fetch(Ecto.Queryable.t(), id) :: Result.t(term, :not_found)
  def fetch(queryable, id) do
    queryable |> get(id) |> Result.new(:not_found)
  end

  @doc """
  Busca e retorna apenas a primeira entrada de um registro no banco de dados.
  """
  @spec fetch_one(Ecto.Queryable.t()) :: Result.t(term, :not_found)
  def fetch_one(queryable) do
    queryable |> one() |> Result.new(:not_found)
  end

  @doc """
  Busca um registro no banco de dados a partir de um campos específico.
  """
  @spec fetch_by(Ecto.Queryable.t(), keyword) :: Result.t(term, :not_found)
  def fetch_by(queryable, params) do
    queryable |> get_by(params) |> Result.new(:not_found)
  end

  @doc """
  Cria uma transação no banco, aplicando a função passada por argumento.
  Caso ocorra um erro, a transação é revertida e nenhuma modificação é realizada.
  """
  @spec transact((... -> term), keyword) :: Result.t(term, Ecto.Changeset.t())
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
