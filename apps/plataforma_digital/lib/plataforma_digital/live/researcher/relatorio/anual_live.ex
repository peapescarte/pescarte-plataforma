defmodule PlataformaDigital.Researcher.Relatorio.AnualLive do
  use PlataformaDigital, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias ModuloPesquisa.Models.RelatorioAnualPesquisa

  @locale "pt_BR"

  # Título de cada campo completo e os respectivos ids
  @report_field_names [
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

  @impl true
  def mount(_, _, socket) do
    # TODO: finalizar tela
    relatorio_anual =
      %RelatorioAnualPesquisa{}
      |> Ecto.Changeset.change()
      |> to_form(as: :relatorio_anual)

    {:ok,
     socket
     |> assign(field_names: @report_field_names)
     |> assign(year: get_formatted_year(Date.utc_today()))
     |> assign(form: relatorio_anual)}
  end

  attr :form, :any, required: true
  attr :label, :string, required: true
  attr :id, :string, required: true

  defp report_field(assigns) do
    ~H"""
    <.text_area field={@form[@id]} class="report-field">
      <:label>
        <.text size="h3" color="text-blue-100">
          <%= @label %>
        </.text>
      </:label>
    </.text_area>
    """
  end

  defp get_formatted_year(%Date{} = today) do
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year}
  end

  # Events

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end
end
