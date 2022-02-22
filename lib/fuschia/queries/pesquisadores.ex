defmodule Fuschia.Queries.Pesquisadores do
  @moduledoc """
  Queries para interagir com `Pesquisadores`
  """

  import Ecto.Query, only: [from: 2, where: 3, order_by: 3]

  alias Fuschia.Accounts.Pesquisador

  @behaviour Fuschia.Query

  @impl true
  def query do
    from p in Pesquisador,
      left_join: campus in assoc(p, :campus),
      left_join: orientador in assoc(p, :orientador),
      order_by: [desc: p.inserted_at]
  end

  @spec query_by_orientador(binary) :: Ecto.Query.t()
  def query_by_orientador(orientador_cpf) do
    query()
    |> where([p], p.orientador_cpf == ^orientador_cpf)
    |> order_by([p], desc: p.inserted_at)
  end

  @spec query_exists(binary) :: Ecto.Query.t()
  def query_exists(usuario_cpf) do
    where(Pesquisador, [p], p.usuario_cpf == ^usuario_cpf)
  end

  @impl true
  def relationships do
    [
      orientador: [usuario: :contato],
      orientandos: [usuario: :contato],
      usuario: :contato,
      campus: :cidade
    ]
  end
end
