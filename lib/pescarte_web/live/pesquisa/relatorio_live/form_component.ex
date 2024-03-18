defmodule PescarteWeb.Pesquisa.RelatorioLive.FormComponent do
  use PescarteWeb, :live_component

  import Timex.Format.DateTime.Formatter, only: [lformat!: 3]

  alias Pescarte.ModuloPesquisa.Handlers.RelatoriosHandler
  alias Pescarte.ModuloPesquisa.Repository

  @locale "pt_BR"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="report-wrapper">
      <.text size="h1" color="text-blue-100">
        <%= @title %>
      </.text>

      <.form for={@form} id="report-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <div class="input-date-group" style="display: flex;">
          <div class="input-date">
            <.text size="h3" color="text-blue-100">Início período</.text>
            <.text_input type="date" field={@form[:data_inicio]} />
          </div>
          <div class="input-date">
            <.text size="h3" color="text-blue-100">Fim período</.text>
            <.text_input type="date" field={@form[:data_fim]} />
          </div>
        </div>

        <.inputs_for :let={f} field={@form[@conteudo]}>
          <.report_field
            :for={{label, name} <- @fields}
            field={f[name]}
            disabled={@form.data.status == :entregue}
            label={label}
          />
        </.inputs_for>

        <.text_input type="hidden" field={@form[:tipo]} value={@tipo} />
        <.text_input type="hidden" field={@form[:pesquisador_id]} value={@pesquisador_id} />
        <.text_input type="hidden" field={@form[:status]} value="pendente" />

        <div class="buttons-wrapper">
          <.button
            name="save"
            value="save-report"
            style="primary"
            phx-disable-with="Salvando..."
            submit
            disabled={not @form.source.valid? or @form.data.status == :entregue}
          >
            <Lucideicons.save /> Salvar respostas
          </.button>
          <.button
            name="save"
            value="send-report"
            style="primary"
            phx-disable-with="Enviando..."
            submit
            disabled={not @form.source.valid? or @form.data.status == :entregue}
          >
            <Lucideicons.send /> Enviar relatório
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{relatorio: relatorio} = assigns, socket) do
    changeset = RelatoriosHandler.change_relatorio_pesquisa(relatorio)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign_form_data(assigns)}
  end

  @impl true
  def handle_event("validate", %{"relatorio_pesquisa" => relatorio_params}, socket) do
    changeset =
      socket.assigns.relatorio
      |> RelatoriosHandler.change_relatorio_pesquisa(relatorio_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"save" => "save-report", "relatorio_pesquisa" => relatorio_params},
        socket
      ) do
    save_relatorio(socket, socket.assigns.action, relatorio_params)
  end

  def handle_event(
        "save",
        %{"save" => "send-report", "relatorio_pesquisa" => relatorio_params},
        socket
      ) do
    params =
      relatorio_params
      |> put_in(["status"], "entregue")
      |> put_in(["data_entrega"], Date.utc_today())

    save_relatorio(socket, socket.assigns.action, params)
  end

  defp save_relatorio(socket, :edit, relatorio_params) do
    case Repository.upsert_relatorio_pesquisa(socket.assigns.relatorio, relatorio_params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply,
         socket
         |> put_flash(:success, "Relatório atualizado com sucesso!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_relatorio(socket, :new, relatorio_params) do
    case Repository.upsert_relatorio_pesquisa(relatorio_params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply,
         socket
         |> put_flash(:success, "Relatório criado com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_form_data(socket, %{tipo: "mensal"}) do
    today = get_formatted_today(Date.utc_today())

    socket
    |> assign(:conteudo, :conteudo_mensal)
    |> assign(
      :title,
      "Relatório Mensal de Pesquisa #{today.month} de #{today.month_word} de #{today.year}"
    )
    |> assign(:fields, get_report_fields(:mensal))
  end

  defp assign_form_data(socket, %{tipo: "trimestral"}) do
    today = get_formatted_today(Date.utc_today())

    socket
    |> assign(:conteudo, :conteudo_trimestral)
    |> assign(
      :title,
      "Relatório Trimestral de Pesquisa do #{today.quarterly}º Trimestre de #{today.year}"
    )
    |> assign(:fields, get_report_fields(:trimestral))
  end

  defp assign_form_data(socket, %{tipo: "anual"}) do
    today = get_formatted_today(Date.utc_today())

    socket
    |> assign(:conteudo, :conteudo_anual)
    |> assign(:title, "Relatório Anual de Pesquisa de #{today.year}")
    |> assign(:fields, get_report_fields(:anual))
  end

  defp get_report_fields(:mensal) do
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

  defp get_report_fields(:trimestral) do
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

  defp get_report_fields(:anual) do
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

  defp get_formatted_today(%Date{month: month} = today) do
    quarterly = Timex.quarter(today)
    month_word = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month_word: month_word, month: month, quarterly: quarterly}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp report_field(assigns) do
    ~H"""
    <.text_area
      id={@field.id}
      name={@field.name}
      value={@field.value}
      disabled={@disabled}
      class="report-field"
    >
      <:label>
        <.text size="h3" color="text-blue-100">
          <%= @label %>
        </.text>
      </:label>
    </.text_area>
    """
  end
end
