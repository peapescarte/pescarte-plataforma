defmodule PlataformaDigital.Pesquisa.Relatorio.MensalLive.FormComponent do
  use PlataformaDigital, :live_component

  alias ModuloPesquisa.Handlers.RelatoriosHandler
  alias ModuloPesquisa.Repository

  @impl true
  def render(assigns) do
    ~H"""
    <div class="monthly-report-wrapper">
      <.text size="h1" color="text-blue-100">
        Relatório Mensal de Pesquisa de <%= @today.month_word %> de <%= @today.year %>
      </.text>

      <.form for={@form} phx-target={@myself} phx-change="validate" phx-submit="save">
        <.report_field :for={{label, name} <- @field_names} field={@form[name]} label={label} />

        <.text_input type="hidden" field={@form[:pesquisador_id]} value={@pesquisador_id} />
        <.text_input type="hidden" field={@form[:mes]} value={@today.month} />
        <.text_input type="hidden" field={@form[:ano]} value={@today.year} />

        <div class="buttons-wrapper">
          <.button style="primary" phx-disable-with="Salvando..." submit>
            <Lucideicons.save /> Salvar respostas
          </.button>
          <.button style="primary" submit>
            <Lucideicons.send /> Enviar relatório
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{relatorio: relatorio} = assigns, socket) do
    changeset = RelatoriosHandler.change_relatorio_mensal(relatorio)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"relatorio_mensal_pesquisa" => params}, socket) do
    changeset =
      socket.assigns.relatorio
      |> RelatoriosHandler.change_relatorio_mensal(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"relatorio_mensal_pesquisa" => params}, socket) do
    save_relatorio(socket, socket.assigns.action, params)
  end

  defp save_relatorio(socket, :edit, params) do
    case Repository.upsert_relatorio_mensal(socket.assigns.relatorio, params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply,
         socket
         |> assign_form(RelatoriosHandler.change_relatorio_mensal(relatorio))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_relatorio(socket, :new, params) do
    case Repository.upsert_relatorio_mensal(params) do
      {:ok, relatorio} ->
        notify_parent({:saved, relatorio})

        {:noreply,
         socket
         |> put_flash(:info, "Relatório salvo com sucesso!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

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
end
