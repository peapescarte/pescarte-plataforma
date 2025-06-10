defmodule Seeder.SeederRunner do
  @moduledoc """
  Runner para inserir registros no banco de dados utilizando funções de inserção fornecidas.
  """

  def insert_records(records, insert_fun, error_message) do
    Enum.map(records, fn record ->
      case insert_fun.(record) do
        {:ok, inserted_record} ->
          inserted_record

        {:error, changeset} ->
          IO.puts("Erro ao inserir #{error_message}: #{inspect(record)}")
          IO.inspect(changeset.errors)
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
