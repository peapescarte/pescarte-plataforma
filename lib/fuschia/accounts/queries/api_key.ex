defmodule Fuschia.Accounts.Queries.ApiKey do
  @moduledoc """
  Queries para interagir com `ApiKey`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.Accounts.Models.ApiKey

  @behaviour Fuschia.Query

  @impl true
  def query do
    from a in ApiKey,
      where: a.active == true
  end

  @impl true
  def relationships, do: []
end
