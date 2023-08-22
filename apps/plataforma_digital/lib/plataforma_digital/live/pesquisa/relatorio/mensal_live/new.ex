defmodule PlataformaDigital.Pesquisa.Relatorio.MensalLive.New do
  use PlataformaDigital, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias ModuloPesquisa.Adapters.RelatorioAdapter
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
  def mount(_params, _session, socket) do
    schedule_save()

    form =
      %RelatorioMensalPesquisa{}
      |> Repository.change_relatorio_mensal()
      |> to_form()

    {:ok,
     socket
     |> assign(field_names: @report_field_names)
     |> assign(today: get_formatted_today(Date.utc_today()))
     |> assign(page_title: "Plataforma PEA Pescarte || Criar relatório mensal")
     |> assign(form: form)
     |> assign(success_message: nil)}
  end

  attr(:field, Phoenix.HTML.FormField)
  attr(:label, :string, required: true)

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
      |> Repository.change_relatorio_mensal(params)
      |> Map.put("action", :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"relatorio_mensal_pesquisa" => params}, socket) do
    params = handle_params(params, socket)

    case Repository.upsert_relatorio_mensal(socket.assigns.form.data, params) do
      {:ok, relatorio_mensal} ->
        {:noreply,
         socket
         |> put_flash(:info, "Relatório mensal criado com sucesso!")
         |> redirect(to: ~p"/app/pesquisa/relatorios/mensal/#{relatorio_mensal.id_publico}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_info(:store, socket) do
    schedule_save()

    params = handle_params(socket.assigns.form.params, socket)

    case Repository.upsert_relatorio_mensal(socket.assigns.form.data, params) do
      {:ok, relatorio_mensal} ->
        form =
          relatorio_mensal
          |> Repository.change_relatorio_mensal()
          |> to_form()

        {:noreply,
         socket
         |> assign(form: form)
         |> assign(success_message: "Salvando relatório...")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp get_formatted_today(%Date{} = today) do
    month_in_words = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month: month_in_words}
  end

  defp handle_params(params, socket) do
    id_publico = socket.assigns.current_user.pesquisador.id_publico
    %_{month: month, year: year} = Date.utc_today()

    params
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, String.trim(v)) end)
    |> Map.put("mes", month)
    |> Map.put("ano", year)
    |> Map.put("pesquisador_id", id_publico)
  end

  defp schedule_save do
    # 2 minutes
    Process.send_after(self(), :store, 2 * 60_000)
  end
end
