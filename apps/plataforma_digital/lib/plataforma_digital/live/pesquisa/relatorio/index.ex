defmodule PlataformaDigital.Pesquisa.RelatorioLive.Index do
  use PlataformaDigital, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias ModuloPesquisa.Models.RelatorioPesquisa
  alias ModuloPesquisa.Repository

  @locale "pt_BR"

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:tipo_relatorio, params["tipo"])
     |> assign(:field_names, get_report_field_names(params))
     |> assign(:today, get_formatted_today(Date.utc_today()))
     |> assign(:pesquisador_id, socket.assigns.current_user.pesquisador.id_publico)}
  end

  defp parse_form_title_by_type(%{assigns: assigns}) do
    case assigns.tipo_relatorio do
      "mensal" ->
        "Relatório Mensal de Pesquisa #{assigns.today.month} de #{assigns.today.month_word} de #{assigns.today.year}"

      "trimestral" ->
        "Relatório Trimestral de Pesquisa do #{assigns.today.quarterly}º Trimestre de #{assigns.today.year}"

      "anual" ->
        "Relatório Mensal de Pesquisa do ano de #{assigns.today.year}"
    end
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp get_report_field_names("mensal") do
    [
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
  end

  defp get_report_field_names("trimestral") do
    [
      {"Título", :titulo},
      {"Resumo", :resumo},
      {"Introdução", :introducao},
      {"Embasamento Teórico", :embasamento_teorico},
      {"Resultados Preliminares", :resultados_preliminares},
      {"Atividades Acadêmicas", :atividades_academicas},
      {"Atividades Não Acadêmicas", :atividades_nao_academicas},
      {"Referências", :referencias}
    ]
  end

  defp get_report_field_names("anual") do
    [
      {"Plano de Trabalho", :plano_de_trabalho},
      {"Resumo", :resumo},
      {"Introdução", :introducao},
      {"Embasamento Teórico", :embasamento_teorico},
      {"Resultados", :resultados},
      {"Atividades Acadêmicas", :atividades_academicas},
      {"Atividades Não Acadêmicas", :atividades_nao_academicas},
      {"Conclusão", :conclusao},
      {"Referências", :referencias}
    ]
  end

  defp get_report_field_names(_), do: get_report_field_names("mensal")

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo relatório")
    |> assign(:form_title, parse_form_title_by_type(socket))
    |> assign(:relatorio, %RelatorioPesquisa{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    relatorio = Repository.fetch_relatorio_pesquisa_by_id(id)

    socket
    |> assign(:page_title, "Editar relatório")
    |> assign(:form_title, parse_form_title_by_type(socket))
    |> assign(:relatorio, relatorio)
  end

  defp get_formatted_today(%Date{month: month} = today) do
    quarterly = Timex.quarter(today)
    month_word = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month_word: month_word, month: month, quarterly: quarterly}
  end
end
