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

      <.form for={@form} phx-target={@myself} phx-change="validate" phx-submit="save">
        <div class="input-date-group" style="display: flex;">
          <.text_input type="date" label="Início período" field={@form[:data_inicio]} />
          <.text_input type="date" label="Fim periodo" field={@form[:data_fim]} />
        </div>

        <.inputs_for :let={f} field={@form[get_embedded_conteudo(assigns)]}>
          <.report_field
            :for={{label, name} <- @field_names}
            field={f[name]}
            disabled={@form.data.status == :entregue}
            label={label}
          />
        </.inputs_for>

        <.text_input type="hidden" field={@form[:tipo]} value={@tipo_relatorio} />
        <.text_input type="hidden" field={@form[:pesquisador_id]} value={@pesquisador_id} />
        <.text_input type="hidden" field={@form[:status]} value="pendente" />
        <.text_input type="hidden" field={@form[:data_limite]} value={get_data_limite(assigns)} />

        <div class="buttons-wrapper">
          <.button
            style="primary"
            phx-disable-with="Salvando..."
            submit
            disabled={not @form.source.valid? or @form.data.status == :entregue}
          >
            <Lucideicons.save /> Salvar respostas
          </.button>
          <.button
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
     |> assign_form(changeset)}
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
  def handle_event("save", %{"relatorio_pesquisa" => params}, socket) do
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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp get_embedded_conteudo(%{tipo_relatorio: tipo_relatorio}) do
    case tipo_relatorio do
      "mensal" -> :conteudo_mensal
      "trimestral" -> :conteudo_trimestral
      "anual" -> :conteudo_anual
    end
  end

  defp get_data_limite(%{tipo_relatorio: tipo_relatorio, today: today}) do
    case tipo_relatorio do
      "mensal" ->
        Date.from_iso8601!("#{today.year}-#{today.month}-15")

      "trimestral" ->
        Date.from_iso8601!("#{today.year}-#{today.month}-10")

      "anual" ->
        Date.utc_today()
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
end
