defmodule Backend.CarboniteHelpers do
  def carbonite_override_mode(_) do
    Carbonite.override_mode(Backend.Repo)

    :ok
  end

  def current_transaction_meta do
    Carbonite.Query.current_transaction()
    |> Backend.Repo.one!()
    |> Map.fetch(:meta)
  end
end
