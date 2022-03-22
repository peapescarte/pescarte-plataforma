defmodule Fuschia.ApiKeysDevSeeds do
  @moduledoc false

  alias Fuschia.Accounts.Models.ApiKeyModel
  alias Fuschia.Repo

  @spec run :: list(ApiKey.t())
  def run do
    IO.puts("==> Running ApiKey seeds")

    Enum.map(api_keys(), &insert_or_update!/1)
  end

  defp insert_or_update!(attrs) do
    changeset =
      case Repo.get_by(ApiKeyModel, key: attrs.key) do
        nil -> %ApiKeyModel{}
        api_key -> api_key
      end

    changeset
    |> ApiKeyModel.changeset(attrs)
    |> Repo.insert_or_update!()
  end

  defp api_keys do
    [
      %{
        key: "77a991a1-9086-4e88-a7db-0143c940cb96",
        description: "Fuschia Dev",
        active: true
      }
    ]
  end
end
