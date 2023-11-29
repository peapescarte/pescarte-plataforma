defmodule PlataformaDigital.Pesquisa.Relatorio.FormComponent do
  use PlataformaDigital, :live_component

  alias ModuloPesquisa.Handlers.RelatoriosHandler
  alias ModuloPesquisa.Repository

  @impl true
  def render(assigns) do
    ~H"""
    <div class="report-wrapper">
      <.text size="h1" color="text-blue-100">
        <%= @form_title %>
      </.text>

      <.form
        for={@form}
        id="relatorio-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="input-date-group" style="display: flex;">
          <.text_input type="date" label="Início período" field={@form[:data_inicio]} />
          <.text_input type="date" label="Fim periodo" field={@form[:data_fim]} />
        </div>

        <.inputs_for :let={f} field={@form[@conteudo]}>
          <.report_field
            :for={{label, name} <- @field_names}
            field={f[name]}
            disabled={@form.data.status == :entregue}
            label={label}
          />
        </.inputs_for>

        <.text_input type="hidden" field={@form[:tipo]} value={@report_type} />
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
  def handle_event("validate", %{"relatorio_pesquisa" => params}, socket) do
    changeset =
      socket.assigns.relatorio
      |> RelatoriosHandler.change_relatorio_pesquisa(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"save" => "save-report", "relatorio_pesquisa" => params}, socket) do
    handle_store(socket, socket.assigns.action, params)
  end

  @impl true
  def handle_event("save", %{"save" => "send-report", "relatorio_pesquisa" => params}, socket) do
    params =
      params
      |> put_in(["status"], "entregue")
      |> put_in(["data_entrega"], Date.utc_today())

    handle_store(socket, socket.assigns.action, params)
  end

  defp handle_store(socket, :edit, params) do
    case Repository.upsert_relatorio_pesquisa(socket.assigns.relatorio, params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply,
         socket
         |> assign_form(RelatoriosHandler.change_relatorio_pesquisa(relatorio))
         |> push_redirect(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp handle_store(socket, :new, params) do
    case Repository.upsert_relatorio_pesquisa(params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply, push_redirect(socket, to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_form_data(socket, %{report_type: "mensal"} = assigns) do
    socket
    |> assign(:report_type, :mensal)
    |> assign(:conteudo, :conteudo_mensal)
    |> assign(
      :form_title,
      "Relatório Mensal de Pesquisa #{assigns.today.month} de #{assigns.today.month_word} de #{assigns.today.year}"
    )
    |> assign(:field_names, get_report_field_names(:mensal))
  end

  defp assign_form_data(socket, %{report_type: "trimestral"} = assigns) do
    socket
    |> assign(:report_type, :trimestral)
    |> assign(:conteudo, :conteudo_trimestral)
    |> assign(
      :form_title,
      "Relatório Trimestral de Pesquisa do #{assigns.today.quarterly}º Trimestre de #{assigns.today.year}"
    )
    |> assign(:field_names, get_report_field_names(:trimestral))
  end

  defp assign_form_data(socket, %{report_type: "anual"} = assigns) do
    socket
    |> assign(:report_type, :anual)
    |> assign(:conteudo, :conteudo_anual)
    |> assign(
      :form_title,
      "Relatório Mensal de Pesquisa #{assigns.today.month} de #{assigns.today.month_word} de #{assigns.today.year}"
    )
    |> assign(:field_names, get_report_field_names(:anual))
  end

  defp get_report_field_names(:mensal) do
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

  defp get_report_field_names(:trimestral) do
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

  defp get_report_field_names(:anual) do
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
end
