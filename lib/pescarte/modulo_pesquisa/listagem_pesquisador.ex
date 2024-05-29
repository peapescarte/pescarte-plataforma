defmodule Pescarte.ModuloPesquisa.ListagemPesquisador do
  import Ecto.Query

  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  def run do
    Replica.all(query())
  end

  defp query do
    from p in Pesquisador,
      join: u in assoc(p, :usuario),
      order_by: u.primeiro_nome,
      select: {fragment("CONCAT(?, ' ', ?)", u.primeiro_nome, u.sobrenome), p.id}
  end
end
