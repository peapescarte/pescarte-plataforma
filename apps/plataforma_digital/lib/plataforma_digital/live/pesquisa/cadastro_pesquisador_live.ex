defmodule PlataformaDigital.Pesquisa.CadastroPesquisadorLive do
  use PlataformaDigital, :auth_live_view

  @impl true
  def mount(_cadastro_params, _session, socket) do
    #    cadastro_params = %{"form" => form, "field_names" => field_names}
    #    cadastro_params = %{"primeiro_nome" => primeiro_nome, "sobrenome" => sobrenome, "data_nascimento" => data_nascimento}
    #      "cpf" => cpf, "telefone" => telefone, "contato_email" => contato_email, "tipo" => tipo,
    #      "rua" => rua, "numero" => numero, "cidade" => cidade, "cep" => cep, "bolsa" => bolsa} = cadastro_params
    {:ok,
     socket
     |> assign(:form_title, "Cadastrar Novo Pesquisador")
     |> assign(:form, to_form(%{}, as: :user))
#     |> assign(:form_dados, get_dados_cadastro)
     |> assign(:field_names, get_cadastro_field_names(:cadastro))}
  end

  # para criar um user no login:
  # def create(conn, %{"user" => user_params}) do
  #    %{"cpf" => cpf, "password" => password} = user_params

  #    case UsuarioHandler.fetch_usuario_by_cpf_and_password(cpf, password) do
  #      {:error, :not_found} -> render(conn, :show, error_message: @err_msg)
  #      {:ok, user} -> Authentication.log_in_user(conn, user, user_params)
  #    end
  #  end

  #  @impl true
  #  def handle_params(params, _uri, socket) do
  #    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  #  end

  #  defp apply_action(socket, :new, _params) do
  #    socket
  #    |> assign(:title, "Novo Pesquisador")
  #    |> assign(:cadastro, %Pesquisador{})
  #  end

  defp get_cadastro_field_names(:cadastro) do
    [
      {"Dados Pessoais", :dados},
      {"Endereço", :endereco},
      {"Vínculo Institucional", :vinculo},
      {"Orientador", :orientador}
    ]

    #  %{dados: dados, endereco: endereco, vinculo: vinculo}
  end

#  defp get_dados_cadastro do
#    [
#      {"primeiro_nome", :primeiro_nome},
#      {"sobrenome", :sobrenome},
#      {"data_nascimento", :data_nascimento}
#    ]
#  end

  #  @impl true    trecho para entender.....
  #  {:ok, assign(socket, note_text: "", draft_notes: [], published_notes: [], error: "")}
  #  def handle_event("create_pesquisador", %{"note_text" => note_text}, socket) do
  #  {:noreply, assign(socket, draft_notes: [note_text | socket.assigns.draft_notes])}
  #  end
end
