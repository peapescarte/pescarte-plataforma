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

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp get_report_field_names(%{"tipo" => "mensal"}) do
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

  defp get_report_field_names(%{"tipo" => "trimestral"}) do
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

  defp get_report_field_names(%{"tipo" => "anual"}) do
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

  defp get_report_field_names(_), do: get_report_field_names(%{"tipo" => "mensal"})

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo relatório")
    |> assign(:relatorio, %RelatorioPesquisa{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    relatorio = Repository.fetch_relatorio_pesquisa_by_id(id)

    socket
    |> assign(:page_title, "Editar relatório")
    |> assign(:relatorio, relatorio)
    |> assign(:tipo_relatorio, to_string(relatorio.tipo))
  end

  defp get_formatted_today(%Date{month: month} = today) do
    month_word = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month_word: month_word, month: month}
  end
end
