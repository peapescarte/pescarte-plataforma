defmodule Fuschia.ModuloPesquisa.Queries.NucleoQueries do
  @moduledoc """
  Queries para interagir com `Nucleo`
  """

  import Ecto.Query, only: [from: 2]

  alias Fuschia.ModuloPesquisa.Models.NucleoModel

  @behaviour Fuschia.Query

  @impl true
  def query do
    from n in NucleoModel,
      order_by: [desc: n.inserted_at]
  end

  @impl true
  def relationships, do: [:linhas_pesquisa]
end
