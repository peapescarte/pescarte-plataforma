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
          <.text_input type="date" label="Início período" field={@form[:data_inicio]} />
          <.text_input type="date" label="Fim periodo" field={@form[:data_fim]} />
        </div>

        <.inputs_for :let={f} field={@form[@conteudo]}>
          <.text_area
            :for={{label, name} <- @fields}
            field={f[name]}
            disabled={@form.data.status == :entregue}
          >
            <:label>
              <.text size="h3" color="text-blue-100">
                <%= label %>
              </.text>
            </:label>
          </.text_area>
        </.inputs_for>

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
  def handle_event("validate", %{"relatorio" => relatorio_params}, socket) do
    changeset =
      socket.assigns.relatorio
      |> RelatoriosHandler.change_relatorio_pesquisa(relatorio_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"relatorio" => relatorio_params}, socket) do
    save_relatorio(socket, socket.assigns.action, relatorio_params)
  end

  defp save_relatorio(socket, :edit, relatorio_params) do
    case Repository.upsert_relatorio_pesquisa(socket.assigns.relatorio, relatorio_params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply,
         socket
         |> put_flash(:info, "Relatório atualizado com sucesso!")
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
         |> put_flash(:info, "Relatório criado com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_form_data(socket, %{type: "mensal"}) do
    today = get_formatted_today(Date.utc_today())

    socket
    |> assign(:conteudo, :conteudo_mensal)
    |> assign(
      :title,
      "Relatório Mensal de Pesquisa #{today.month} de #{today.month_word} de #{today.year}"
    )
    |> assign(:fields, get_report_fields(:mensal))
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

  defp get_formatted_today(%Date{month: month} = today) do
    quarterly = Timex.quarter(today)
    month_word = lformat!(today, "{Mfull}", @locale)
    year = lformat!(today, "{YYYY}", @locale)

    %{year: year, month_word: month_word, month: month, quarterly: quarterly}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
