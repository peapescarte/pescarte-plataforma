# lib/seeder_utils.ex
defmodule Seeder.SeederUtils do
  @doc """
  Normaliza uma string convertendo-a para minúsculas e removendo espaços extras.
  """
  def normalize_string(nil), do: nil

  def normalize_string(string) when is_binary(string) do
    string
    |> String.downcase()
    |> String.trim()
  end
end
