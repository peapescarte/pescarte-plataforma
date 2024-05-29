defmodule Pescarte.ModuloPesquisa.ListagemLinhaPesquisa do
  import Ecto.Query

  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa

  def run do
    query()
    |> Replica.all()
    |> Enum.map(&{&1.desc_curta, &1.id})
  end

  defp query do
    from lp in LinhaPesquisa,
      select: [:id, :desc_curta, :numero],
      order_by: {:asc, :numero}
  end
end
