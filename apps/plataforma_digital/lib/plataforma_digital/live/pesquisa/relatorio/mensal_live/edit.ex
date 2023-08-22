defmodule PlataformaDigital.Pesquisa.Relatorio.MensalLive.Edit do
  use PlataformaDigital, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias ModuloPesquisa.Handlers.RelatoriosHandler
  alias ModuloPesquisa.Models.RelatorioMensalPesquisa
  alias ModuloPesquisa.Repository

  @locale "pt_BR"

  # Título de cada campo completo e os respectivos ids
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
  def mount(%{"relatorio_mensal_id" => relatorio_mensal_id}, _session, socket) do
    schedule_save()

    form =
      relatorio_mensal_id
      |> Repository.fetch_relatorio_pesquisa_mensal_by_id()
      |> RelatoriosHandler.change_relatorio_mensal()
      |> to_form()

    {:ok,
     socket
     |> assign(field_names: @report_field_names)
     |> assign(today: get_formatted_today(Date.utc_today()))
     |> assign(page_title: "Plataforma PEA Pescarte || Atualizar relatório mensal")
     |> assign(form: form)
     |> assign(toast: nil)}
  end

  attr :field, Phoenix.HTML.FormField
  attr :label, :string, required: true

  defp report_field(assigns) do
    ~H"""
    <.text_area id={@field.id} name={@field.name} value={@field.value} class="report-field">
      <:label>
        <.text size="h3" color="text-blue-100">
          <%= @label %>
        </.text>
      </:label>
    </.text_area>
    """
  end

  @impl true
  def handle_event("change", %{"relatorio_mensal_pesquisa" => params}, socket) do
    form =
      socket.assigns.form.data
      |> RelatoriosHandler.change_relatorio_mensal(params)
      |> Map.put("action", :update)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"relatorio_mensal_pesquisa" => params}, socket) do
    params = handle_params(params)

    case Repository.upsert_relatorio_mensal(socket.assigns.form.data, params) do
      {:ok, %RelatorioMensalPesquisa{}} ->
        {:noreply, redirect(socket, to: ~p"/app/pesquisa/relatorios")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(form: to_form(changeset))
         |> assign(toast: %{type: "error", message: "Erro ao salvar relatório..."})}
    end
  end

  @impl true
  def handle_info(:store, socket) do
    schedule_save()

    params = handle_params(socket.assigns.form.params)

    case Repository.upsert_relatorio_mensal(socket.assigns.form.data, params) do
      {:ok, %RelatorioMensalPesquisa{} = relatorio_mensal} ->
        form =
          relatorio_mensal
          |> RelatoriosHandler.change_relatorio_mensal()
          |> to_form()

        {:noreply,
         socket
         |> assign(form: form)
         |> assign(toast: %{type: "success", message: "Salvando relatório..."})}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(form: to_form(changeset))
         |> assign(toast: %{type: "error", message: "Erro ao salvar relatório..."})}
    end
  end

  defp handle_params(params) do
    Enum.reduce(params, %{}, fn {k, v}, acc -> Map.put(acc, k, String.trim(v)) end)
  end

  defp get_formatted_today(%Date{} = today) do
    month_in_words = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month: month_in_words}
  end

  defp schedule_save do
    # 2 minutes
    Process.send_after(self(), :store, 2 * 60_000)
  end
end
