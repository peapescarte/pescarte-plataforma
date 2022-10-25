defmodule Pescarte.CarboniteHelpers do
  def carbonite_override_mode(_) do
    Carbonite.override_mode(Pescarte.Repo)

    :ok
  end

  def current_transaction_meta do
    Carbonite.Query.current_transaction()
    |> Pescarte.Repo.one!()
    |> Map.fetch(:meta)
  end
end
