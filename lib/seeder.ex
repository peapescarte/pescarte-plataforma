defmodule Seeder do
  require Logger
  alias Pescarte.Database.Repo

  @spec append_multi(Ecto.Multi.t(), list(term), binary) :: Ecto.Multi.t()
  def append_multi(multi, entries, key) do
    entries
    |> Enum.with_index()
    |> Enum.reduce(multi, fn {entry, idx}, acc ->
      Ecto.Multi.insert(acc, :"#{key}-#{idx}", entry)
    end)
  end

  @spec transact(Ecto.Multi.t()) :: :ok | :error
  def transact(multi) do
    case Repo.transaction(multi) do
      {:ok, _changes} ->
        :ok

      {:error, _, changeset, _} ->
        Logger.error(inspect(changeset))
        :error
    end
  end

  @spec seed(list(struct), binary) :: :ok | :error
  def seed(entries, key) do
    Logger.info("==> Executando seeds de #{String.capitalize(key)}")
    Repo.query!("TRUNCATE table #{key} CASCADE")

    Ecto.Multi.new()
    |> append_multi(entries, key)
    |> transact()
  end

  defmodule Entry do
    @callback entries :: list(struct)
  end

  # Seeds disponiveis
  @callback endereco_seeds :: :ok | :error
  @callback contato_seeds :: :ok | :error
  @callback usuario_seeds :: :ok | :error

  @callback campus_seeds :: :ok | :error
  @callback pesquisador_seeds :: :ok | :error
  @callback categoria_seeds :: :ok | :error
  @callback tag_seeds :: :ok | :error
  @callback midia_seeds :: :ok | :error
end
