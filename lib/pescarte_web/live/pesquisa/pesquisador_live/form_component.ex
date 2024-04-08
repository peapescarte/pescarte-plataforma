defmodule PescarteWeb.Pesquisa.PesquisadorLive.FormComponent do
  use PescarteWeb, :live_component

  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @impl true
  def render(assigns) do
    ~H"""
    <div class="researcher-wrapper">
      <.text size="h1" color="text-blue-100">
        <%= @title %>
      </.text>

      <.form
        :let={f}
        id="researcher-form"
        for={@form}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.text_input type="hidden" field={f[:pesquisador_id]} value={@pesquisador.id_publico} />

        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Dados Pessoais
          </.text>

          <div class="input-group">
            <.text_input type="text" field={f[:usuario]} />
            <.text_input type="date" field={f[:data_nascimento]} />
            <.text_input type="text" field={f[:cpf]} />
            <.text_input type="text" field={f[:nacionalidade]} />
            <.text_input type="text" field={f[:qualificacao_profissional]} />
            <.text_input type="text" field={f[:telefone]} />
            <.text_input type="text" field={f[:email]} />
            <.checkbox field={f[:aluno]} />
          </div>
        </div>
        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Endereço
          </.text>

          <div class="input-group">
            <.text_input type="text" field={f[:usuario]} />
            <.text_input type="date" field={f[:data_nascimento]} />
            <.text_input type="text" field={f[:cpf]} />
            <.text_input type="text" field={f[:nacionalidade]} />
            <.text_input type="text" field={f[:qualificacao_profissional]} />
            <.text_input type="text" field={f[:telefone]} />
            <.text_input type="text" field={f[:email]} />
            <.checkbox field={f[:aluno]} />
          </div>
        </div>
        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Vínculo Institucional
          </.text>
        </div>
        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Orientador
          </.text>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{pesquisador: pesquisador} = assigns, socket) do
    changeset = Pesquisador.changeset(pesquisador, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
