defmodule PescarteWeb.Pesquisa.PesquisadorLive.FormComponent do
  use PescarteWeb, :live_component

  alias Pescarte.ModuloPesquisa.ListagemLinhaPesquisa
  alias Pescarte.ModuloPesquisa.ListagemPesquisador
  # alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.RegisterPesquisador
  # alias PescarteWeb.DesignSystem.MultipleSelectInput

  require Logger

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
        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Dados Pessoais
          </.text>
          <div class="input-group">
            <div class="input-group-row">
              <.inputs_for :let={uf} field={f[:usuario]}>
                <.text_input field={uf[:primeiro_nome]} type="text" label="Nome" required />
                <.text_input field={uf[:sobrenome]} type="text" label="Sobrenome" required />
                <.text_input
                  field={uf[:data_nascimento]}
                  type="date"
                  label="Data de Nascimento"
                  required
                />
                <.text_input
                  field={uf[:cpf]}
                  type="text"
                  label="CPF"
                  phx-hook="CpfNumberMask"
                  id="user_cpf"
                  required
                />
                <.text_input field={uf[:papel]} type="text" value="pesquisador" hidden />
              </.inputs_for>
            </div>

            <div class="input-group-row">
              <.text_input
                field={f[:formacao]}
                type="text"
                label="Qualificação Profissional"
                required
              />
              <.inputs_for :let={uf} field={f[:usuario]}>
                <.inputs_for :let={cf} field={uf[:contato]}>
                  <.text_input
                    field={cf[:celular_principal]}
                    label="Telefone"
                    type="text"
                    phx-hook="MobileMask"
                    id="mobile"
                    required
                  />
                  <.text_input field={cf[:email_principal]} label="E-mail" type="text" required />
                </.inputs_for>
              </.inputs_for>
            </div>

            <div class="input-group-row">
              <.text_input
                field={f[:data_contratacao]}
                type="date"
                label="Data de Contratação"
                required
              />
              <.text_input
                field={f[:data_termino]}
                type="date"
                label="Término da Contratação"
                required
              />
            </div>

            <div class="input-group-row">
              <.text_input field={f[:link_lattes]} type="text" label="Link Lattes" />
              <.text_input field={f[:link_linkedin]} type="text" label="Link LinkedIn" />
              <.inputs_for :let={uf} field={f[:usuario]}>
                <.text_input field={uf[:link_avatar]} type="text" label="Link Foto de Perfil" />
              </.inputs_for>
            </div>
          </div>
        </div>

        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Endereço
          </.text>

          <div class="input-group">
            <div class="input-group-row">
              <.inputs_for :let={uf} field={f[:usuario]}>
                <.inputs_for :let={cf} field={uf[:contato]}>
                  <.text_input field={cf[:endereco]} label="Endereço" type="text" required />
                </.inputs_for>
              </.inputs_for>
            </div>
          </div>
        </div>

        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Bolsa
          </.text>

          <div class="input-group">
            <div class="input-group-row">
              <.select field={f[:bolsa]} label="Tipo" options={humanize_bolsas()} prompt="" required />
              <.text_input field={f[:data_inicio_bolsa]} type="date" label="Data de Início" required />
              <.text_input field={f[:data_fim_bolsa]} type="date" label="Data de Término" required />
            </div>

            <div class="input-group-row">
              <.select
                field={f[:linha_pesquisa_principal_id]}
                label="Linha de Pesquisa Principal"
                options={ListagemLinhaPesquisa.run()}
                prompt=""
                required
              />
              <!-- <.inputs_for :let={lpf} field={f[:linhas_pesquisa]} append={[%LinhaPesquisa{}]}>
                <.live_component module={MultipleSelectInput} field={lpf[:linha_pesquisa_id]} label="Outras Linhas" id="linhas" prompt="" options={ListagemLinhaPesquisa.run()} />
              </.inputs_for> -->
            </div>
          </div>
        </div>

        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Vínculo Institucional
          </.text>

          <div class="input-group">
            <div class="input-group-row">
              <.inputs_for :let={cf} field={f[:campus]}>
                <.text_input field={cf[:nome_universidade]} label="Nome" type="text" required />
                <.text_input field={cf[:acronimo]} label="Acrônimo" type="text" required />
                <.text_input field={cf[:nome]} label="Campus" type="text" required />
                <.text_input field={cf[:endereco]} label="Endereço" type="text" required />
              </.inputs_for>
            </div>
          </div>
        </div>

        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Orientador
          </.text>

          <.text size="lg" color="text-black-80">
            Preencher somente se o cadastrado tiver orientador.
          </.text>

          <div class="input-group">
            <.select
              field={f[:orientador_id]}
              prompt=""
              options={ListagemPesquisador.run()}
              label="Nome"
            />
          </div>
        </div>

        <div class="input-group-wrapper">
          <.text size="h2" color="text-blue-100">
            Anotações
          </.text>

          <div class="input-group textarea">
            <.text_area field={f[:anotacoes]} placeholder="Inicie uma anotação" />
          </div>
        </div>

        <div class="submit-wrapper">
          <.button style="primary" submit>
            <Lucideicons.save /> Salvar Resposta
          </.button>
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

  @impl true
  def handle_event("validate", %{"pesquisador" => params}, socket) do
    changeset =
      socket.assigns.pesquisador
      |> Pesquisador.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"pesquisador" => params}, socket) do
    case RegisterPesquisador.run(params) do
      {:ok, _} ->
        {:noreply, redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign_form(changeset)
         |> put_flash(:error, "Alguns campos estão incorretos, verifique os erros abaixo")}

      err ->
        Logger.error("""
        [#{__MODULE__}] ==> Falha ao cadastrar Pesquisador
        PARAMS: #{inspect(params, pretty: true)}
        ERROR: #{inspect(err, pretty: true)}
        """)

        {:noreply, socket}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp humanize_bolsas do
    alias Phoenix.Naming

    Pesquisador.tipo_bolsas()
    |> Enum.map(&Naming.humanize/1)
    |> Enum.zip(Pesquisador.tipo_bolsas())
  end
end
