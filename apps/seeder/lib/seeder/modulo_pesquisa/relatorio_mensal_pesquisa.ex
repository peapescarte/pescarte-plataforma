defmodule Seeder.ModuloPesquisa.RelatorioMensalPesquisa do
  alias Database.Repo.Replica
  alias Identidades.Models.Usuario

  alias ModuloPesquisa.Models.RelatorioMensalPesquisa

  @behaviour Seeder.Entry

  defp pesquisador_id_by_cpf(cpf) do
    usuario = Replica.get_by!(Usuario, cpf: cpf)
    pesquisador = Replica.preload(usuario, [:pesquisador])
    pesquisador.id_publico
  end

 @impl true
 def entries do
    [
      %RelatorioMensalPesquisa{
        ano: "2023",
        mes: "Maio",
        status: "Entregue" ,
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
        },
     %RelatorioMensalPesquisa{
        ano: "2023",
        mes: "Maio",
        status: "Atrasado",
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
        },
          %RelatorioMensalPesquisa{
        ano: "2023",
        mes: "Dezembro",
        status: "Atrasado",
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
        },
      %RelatorioMensalPesquisa{
        ano: "2023",
        mes: "Junho",
        status: "Entregue",
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      }
    ]
 end
 end
