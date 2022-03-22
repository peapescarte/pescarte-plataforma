defmodule Fuschia.Accounts.Queries.ApiKeyQueries do
  @moduledoc """
  Queries para interagir com `ApiKey`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.Accounts.Models.ApiKeyModel

  @behaviour Fuschia.Query

  @impl true
  def query do
    from a in ApiKeyModel,
      where: a.active == true
  end

  @impl true
  def relationships, do: []
end
