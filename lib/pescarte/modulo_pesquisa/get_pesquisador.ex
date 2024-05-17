defmodule Pescarte.ModuloPesquisa.GetPesquisador do
  import Ecto.Query

  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  def run(id: id) do
    Replica.one(
      from p in Pesquisador,
        where: p.id == ^id,
        join: u in assoc(p, :usuario),
        join: c in assoc(u, :contato),
        join: ca in assoc(p, :campus),
        join: lpp in assoc(p, :linha_pesquisa_principal),
        preload: [campus: ca, linha_pesquisa_principal: lpp, usuario: {u, contato: c}]
    )
  end
end
