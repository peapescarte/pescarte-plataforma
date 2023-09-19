defmodule PlataformaDigital.Pesquisa.Relatorio.FormComponent do
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
          <.button style="primary" phx-disable-with="Enviando..." submit>
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
