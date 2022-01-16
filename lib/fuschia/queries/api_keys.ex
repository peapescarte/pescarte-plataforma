defmodule Fuschia.Queries.ApiKeys do
  @moduledoc """
  Queries para interagir com `ApiKeys`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.Entities.ApiKey

  @behaviour Fuschia.Query

  @impl true
  def query do
    from a in ApiKey,
      where: a.active == true
  end

  @impl true
  def relationships, do: []
end
