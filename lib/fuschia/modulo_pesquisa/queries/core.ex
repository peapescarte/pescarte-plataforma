defmodule Fuschia.ModuloPesquisa.Queries.Core do
  @moduledoc """
  Queries para interagir com `Nucleo`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.ModuloPesquisa.Models.Core

  @behaviour Fuschia.Query

  @impl true
  def query do
    from n in Core,
      order_by: [desc: n.inserted_at]
  end

  @impl true
  def relationships, do: [:lines]
end
