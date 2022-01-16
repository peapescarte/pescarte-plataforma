defmodule Fuschia.Queries.Cidades do
  @moduledoc """
  Queries para interagir com `Cidades`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.Entities.Cidade

  @behaviour Fuschia.Query

  @impl true
  def query do
    from c in Cidade,
      order_by: [desc: c.created_at]
  end

  @impl true
  def relationships, do: [:campi]
end
