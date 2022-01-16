defmodule Fuschia.Queries.Nucleos do
  @moduledoc """
  Queries para interagir com `Nucleo`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.Entities.Nucleo

  @behaviour Fuschia.Query

  @impl true
  def query do
    from n in Nucleo,
      order_by: [desc: n.created_at]
  end

  @impl true
  def relationships, do: [:linhas_pesquisa]
end
