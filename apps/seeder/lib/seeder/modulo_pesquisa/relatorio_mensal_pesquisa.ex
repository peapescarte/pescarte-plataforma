defmodule Seeder.ModuloPesquisa.RelatorioMensalPesquisa do
  alias Database.Repo.Replica
  alias Identidades.Models.Usuario

  alias ModuloPesquisa.Models.RelatorioMensalPesquisa

  @behaviour Seeder.Entry

  defp pesquisador_id_by_cpf(cpf) do
    usuario =
      Usuario
      |> Replica.get_by!(cpf: cpf)
      |> Replica.preload([:pesquisador])

    usuario.pesquisador.id_publico
  end

  @impl true
  def entries do
    [
      %RelatorioMensalPesquisa{
        ano: 2023,
        mes: 5,
        status: :entregue,
        data_entrega: ~D[2023-05-30],
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      },
      %RelatorioMensalPesquisa{
        ano: 2023,
        mes: 6,
        status: :entregue,
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      },
      %RelatorioMensalPesquisa{
        ano: 2023,
        mes: 12,
        status: :atrasado,
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      },
      %RelatorioMensalPesquisa{
        ano: 2023,
        mes: 7,
        status: :entregue,
        data_entrega: ~D[2023-07-30],
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      }
    ]
  end
end
