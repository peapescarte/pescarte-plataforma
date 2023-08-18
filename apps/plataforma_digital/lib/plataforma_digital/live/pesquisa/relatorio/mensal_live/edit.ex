defmodule PlataformaDigital.Pesquisa.Relatorio.MensalLive.Edit do
  use PlataformaDigital, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias ModuloPesquisa.Adapters.RelatorioAdapter
  alias ModuloPesquisa.Models.RelatorioMensalPesquisa
  alias ModuloPesquisa.Repository
  alias Phoenix.LiveView.Socket

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

    relatorio_mensal =
      relatorio_mensal_id
      |> Repository.fetch_relatorio_pesquisa_mensal_by_id()
      |> Ecto.Changeset.change()
      |> to_form()

    socket =
      socket
      |> assign(field_names: @report_field_names)
      |> assign(today: get_formatted_today(Date.utc_today()))
      |> assign(page_title: "Plataforma PEA Pescarte || Atualizar relatório mensal")
      |> assign(form: relatorio_mensal)
      |> assign(params: %{})

    {:ok, socket}
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
    {:noreply, assign(socket, params: params)}
  end

  @impl true
  def handle_event("save", %{"relatorio_mensal_pesquisa" => params}, socket) do
    form = handle_save(socket.assigns.form.data, socket.assigns.params)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_info(:update, socket) do
    schedule_save()

    form = handle_save(socket.assigns.form.data, socket.assigns.params)

    {:noreply, assign(socket, form: form)}
  end

  defp handle_save(form \\ %RelatorioMensalPesquisa{}, params) do
    params = RelatorioAdapter.parse_params(params)

    case Repository.upsert_relatorio_mensal(form, params) do
      {:ok, relatorio_mensal} ->
        relatorio_mensal
        |> Ecto.Changeset.change(params)
        |> to_form()

      {:error, changeset} ->
        changeset
    end
  end

  defp get_formatted_today(%Date{} = today) do
    month_in_words = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month: month_in_words}
  end

  defp schedule_save do
    # 2 minutes
    Process.send_after(self(), :update, 2 * 60_000)
  end
end
