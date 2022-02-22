defmodule Fuschia.CarboniteHelpers do
  def carbonite_override_mode(_) do
    Carbonite.override_mode(Fuschia.Repo)

    :ok
  end

  def current_transaction_meta do
    Carbonite.Query.current_transaction()
    |> Fuschia.Repo.one!()
    |> Map.fetch(:meta)
  end
end
