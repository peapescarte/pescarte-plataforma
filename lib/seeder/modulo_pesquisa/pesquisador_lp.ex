defmodule Seeder.ModuloPesquisa.PesquisadorLP do
  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Models.PesquisadorLP

  @behaviour Seeder.Entry

  defp pesquisador_id_by(index: index) do
    pesquisadores = Replica.all(Pesquisador)
    Enum.at(pesquisadores, index).id
  end

  defp linha_pesquisa_id_by(numero: numero) do
    Replica.get_by!(LinhaPesquisa, numero: numero).id
  end

  @impl true
  def entries do
    [
      %PesquisadorLP{
        pesquisador_id: pesquisador_id_by(index: 0),
        linha_pesquisa_id: linha_pesquisa_id_by(numero: 1),
        lider?: true
      },
      %PesquisadorLP{
        pesquisador_id: pesquisador_id_by(index: 1),
        linha_pesquisa_id: linha_pesquisa_id_by(numero: 2),
        lider?: false
      },
      %PesquisadorLP{
        pesquisador_id: pesquisador_id_by(index: 2),
        linha_pesquisa_id: linha_pesquisa_id_by(numero: 3),
        lider?: true
      },
      %PesquisadorLP{
        pesquisador_id: pesquisador_id_by(index: 3),
        linha_pesquisa_id: linha_pesquisa_id_by(numero: 4),
        lider?: false
      }
    ]
  end
end
