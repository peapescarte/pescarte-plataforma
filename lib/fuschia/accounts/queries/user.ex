defmodule Fuschia.Accounts.Queries.User do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Fuschia.Accounts.Models.User

  @behaviour Fuschia.Query

  @impl true
  def query do
    from u in User,
      left_join: contato in assoc(u, :contato),
      order_by: [desc: u.inserted_at]
  end

  @impl true
  def relationships, do: [:contato]
end
