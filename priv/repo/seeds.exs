defmodule Seeder do
  require Logger

  @spec append_multi(Ecto.Multi.t(), list(term), binary) :: Ecto.Multi.t()
  def append_multi(multi, entries, key) do
    entries
    |> Enum.with_index()
    |> Enum.reduce(multi, fn {entry, idx}, acc ->
      Ecto.Multi.insert(acc, :"#{key}-#{idx}", entry)
    end)
  end

  def transact(multi) do
    case Pescarte.Repo.transaction(multi) do
      {:ok, _changes} -> :ok
      {:error, _, changeset, _} -> Logger.error(inspect(changeset))
    end
  end

  def endereco_seeds do
    Logger.info("==> Executando seeds de Endereco")
    [{EnderecoSeed, _}] = Code.require_file("priv/repo/seeds/endereco.exs", ".")

    Ecto.Multi.new()
    |> Seeder.append_multi(EnderecoSeed.entries(), "endereço")
    |> Seeder.transact()
  end
end

alias Pescarte.Domains.Accounts
alias Pescarte.Domains.ModuloPesquisa

:ok = Seeder.endereco_seeds()
