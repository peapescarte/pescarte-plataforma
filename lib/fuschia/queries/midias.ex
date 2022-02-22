defmodule Fuschia.Queries.Midias do
  @moduledoc """
  Queries para interagir com `Midias`
  """

  import Ecto.Query, only: [from: 2, join: 4, where: 3]

  alias Fuschia.Entities.Midia

  @behaviour Fuschia.Query

  @impl true
  def query do
    from midia in Midia,
      order_by: [desc: midia.inserted_at]
  end

  @spec query_by_pesquisador(binary) :: Ecto.Query.t()
  def query_by_pesquisador(pesquisador_cpf) do
    query()
    |> join(:inner, [midia], p in assoc(midia, :pesquisador))
    |> where([midia], midia.pesquisador_cpf == ^pesquisador_cpf)
  end

  @impl true
  def relationships, do: [:pesquisador]
end
