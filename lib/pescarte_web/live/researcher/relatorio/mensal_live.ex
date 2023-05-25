defmodule PescarteWeb.Researcher.Relatorio.MensalLive do
  use PescarteWeb, :auth_live_view

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @locale "pt_BR"

  # Título de cada campo completo e os respectivos ids
  @report_field_names [
    {"Ações de Planejamento e Construção da Pesquisa", :planning_action},
    {"Participação em Grupos de Estudos", :study_group},
    {"Reuniões de Orientação", :guidance_metting},
    {"Ações de Pesquisas de Campo, Análise de Dados e Construção Audiovisual", :research_actions},
    {"Participação em Treinamentos e Crusos PEA Pescarte", :training_participation},
    {"Publicação", :publication}
  ]

  @impl true
  def mount(_, _, socket) do
    # TODO: finalizar tela
    relatorio_mensal =
      %RelatorioMensal{}
      |> Ecto.Changeset.change()
      |> to_form(as: :relatorio_mensal)

    {:ok,
     socket
     |> assign(field_names: @report_field_names)
     |> assign(today: get_formatted_today(Date.utc_today()))
     |> assign(form: relatorio_mensal)}
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

  defp get_formatted_today(%Date{} = today) do
    month_in_words = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month: month_in_words}
  end

  # Events

  @impl true
  def handle_event("save", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
