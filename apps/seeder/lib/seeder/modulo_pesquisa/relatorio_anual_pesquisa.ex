defmodule Seeder.ModuloPesquisa.RelatorioAnualPesquisa do
  alias Database.Repo.Replica
  alias Identidades.Models.Usuario
  alias ModuloPesquisa.Models.RelatorioAnualPesquisa

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
      %RelatorioAnualPesquisa{
        ano: 2023,
        mes: 5,
        status: :entregue,
        data_entrega: ~D[2023-05-30],
        link: "https://drive.google.com/drive/folders/1KCHYlN_sbEatoWhUnOh024iSbdwTCpxP",
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      },
      %RelatorioAnualPesquisa{
        ano: 2022,
        mes: 5,
        status: :atrasado,
        link: "https://drive.google.com/drive/folders/1KCHYlN_sbEatoWhUnOh024iSbdwTCpxP",
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      },
      %RelatorioAnualPesquisa{
        ano: 2021,
        mes: 12,
        status: :atrasado,
        link: "https://drive.google.com/drive/folders/1KCHYlN_sbEatoWhUnOh024iSbdwTCpxP",
        pesquisador_id: pesquisador_id_by_cpf("214.047.038-96")
      }
    ]
  end
end
