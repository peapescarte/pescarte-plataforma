defmodule PlataformaDigital.Pesquisa.Relatorio.ListReportLive do
  @moduledoc false

  use Phoenix.LiveView
  use PlataformaDigital, :auth_live_view

  alias ModuloPesquisa.Handlers.RelatoriosHandler

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    list =
      if current_user == :admin do
        RelatoriosHandler.list_relatorios()
      else
        RelatoriosHandler.list_relatorios_from_pesquisador(current_user.pesquisador.id_publico)
      end

    {:ok, assign(socket, relatorios: list, tabela: list)}
  end
  # Tratando os checkbox para poder compilar os escolhidos/marcados:
  # socket
  #  |> assign(:toggle_ids, [])

  def handle_event("toggle-all", %{"value" => "on"}, socket) do
    report_ids = socket.assigns.relatorios |> Enum.map(& &1.id)
    {:noreply, assign(socket, toggle_ids: report_ids)}
  end

  def handle_event("toggle-all", %{}, socket) do
    {:noreply, assign(socket, toggle_ids: [])}
  end

  def handle_event("toggle", %{"toggle-id" => id}, socket) do
    id = String.to_integer(id)
    toggle_ids = socket.assigns.toggle_ids

    toggle_ids =
      if (id in toggle_ids) do
        Enum.reject(toggle_ids, & &1 == id)
      else
        [id|toggle_ids]
      end

    {:noreply, assign(socket, toggle_ids: toggle_ids)}
  end






  def handle_params(%{"search" => "true"} = search, _uri, socket) do
    tabela =
      case search do
        %{"data" => data} ->
          filter_by("data", socket.assigns.relatorios, data)

        %{"tipo" => tipo} ->
          filter_by("tipo", socket.assigns.relatorios, tipo)

        %{"periodo" => periodo} ->
          filter_by("periodo", socket.assigns.relatorios, periodo)

        %{"nome_pesquisador" => nome_pesquisador} ->
          filter_by("nome_pesquisador", socket.assigns.relatorios, nome_pesquisador)

        %{"status" => status} ->
          filter_by("status", socket.assigns.relatorios, status)
      end

    {:noreply, assign(socket, tabela: tabela)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp filter_by("data", relatorios, data) do
    Enum.filter(relatorios, fn relatorio ->
      to_string(relatorio.data) == data
    end)
  end

  defp filter_by("tipo", relatorios, tipo) do
    Enum.filter(relatorios, fn relatorio ->
      to_string(relatorio.tipo) == tipo
    end)
  end

  defp filter_by("periodo", relatorios, periodo) do
    Enum.filter(relatorios, fn relatorio ->
      to_string(relatorio.periodo) == periodo
    end)
  end

  defp filter_by("nome_pesquisador", relatorios, nome_pesquisador) do
    Enum.filter(relatorios, fn relatorio ->
      to_string(relatorio.nome_pesquisador) == nome_pesquisador
    end)
  end

  defp filter_by("status", relatorios, status) do
    Enum.filter(relatorios, fn relatorio ->
      to_string(relatorio.status) == status
    end)
  end

  # Vamos trabalhar o dropdown do "Preencher Relatório" 09-14/10/2023
  @impl true
  def handle_event("mensal_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
    # ~p"/app/pesquisa/relatorios"
  end

  def handle_event("trimestral_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end

  def handle_event("bienal_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end

  def handle_event("anual_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end

  # Trabalhando com o botão "Compila" 23;27/10/2023
  # compila_report não está funcionando!!!!
  @impl true
  def handle_event("compila_report", %{}, socket) do
    toggle_ids = socket.assigns.toggle_ids
    report_to_be_compiled =
  #    RelatoriosHandler.list_relatorios_from_pesquisador(current_user.pesquisador.id_publico)
      RelatorioPesquisa.list_relatorios_from_pesquisador()
    |> Enum.filter(& &1.id in toggle_ids)

    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end


  @impl true
  def handle_event("download_file", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
#    {:ok, file_path} = "caminho/para/arquivo/arquivo_para_download.pdf"
#    send_download_response(socket, file_path)

  end
#  defp send_download_response(socket, file_path) do
#    {:ok, file} = File.read(file_path)
#    socket
#    |> put_flash(:info, "Arquivo baixado com sucesso!")
#    |> send_download(file: file, filename: File.basename(file_path))
#  end

end
