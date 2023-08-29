defmodule PlataformaDigital.Pesquisa.Relatorio.MensalLive.Index do
  use PlataformaDigital, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias ModuloPesquisa.Models.RelatorioMensalPesquisa
  alias ModuloPesquisa.Repository

  @locale "pt_BR"

  @report_field_names [
    {"Ações de Planejamento", :acao_planejamento},
    {"Participação em Grupos de Estudos", :participacao_grupos_estudo},
    {"Ações de Pesquisas de Campo, Análise de Dados e Construção Audiovisual", :acoes_pesquisa},
    {"Participação em Treinamentos e Crusos PEA Pescarte", :participacao_treinamentos},
    {"Publicação", :publicacao},
    {"Previsão de Ação de Planejamento", :previsao_acao_planejamento},
    {"Previsão de Participação em Grupos de Estudo", :previsao_participacao_grupos_estudo},
    {"Previsão de Participação em Treinamentos e Cursos PEA Pescarte",
     :previsao_participacao_treinamentos},
    {"Previsão de Ações de Pesquisa", :previsao_acoes_pesquisa}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:field_names, @report_field_names)
     |> assign(:today, get_formatted_today(Date.utc_today()))
     |> assign(:pesquisador_id, socket.assigns.current_user.pesquisador.id_publico)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(
        {PlataformaDigital.Pesquisa.Relatorio.MensalLive.FormComponent, {:saved, relatorio}},
        socket
      ) do
    {:noreply, assign(socket, :relatorio, relatorio)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Atualizar relatório mensal")
    |> assign(:relatorio, Repository.fetch_relatorio_pesquisa_mensal_by_id(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo relatório mensal")
    |> assign(:relatorio, %RelatorioMensalPesquisa{})
  end

  defp get_formatted_today(%Date{month: month} = today) do
    month_word = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month_word: month_word, month: month}
  end
end
