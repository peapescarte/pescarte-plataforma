defmodule Fuschia.ModuloPesquisa.Queries.Cidade do
  @moduledoc """
  Queries para interagir com `Cidade`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.ModuloPesquisa.Models.Cidade

  @behaviour Fuschia.Query

  @impl true
  def query do
    from c in Cidade,
      order_by: [desc: c.inserted_at]
  end

  @impl true
  def relationships, do: [:campi]
end
