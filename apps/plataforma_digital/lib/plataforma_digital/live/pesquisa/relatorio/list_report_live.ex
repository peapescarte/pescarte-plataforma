defmodule PlataformaDigital.Pesquisa.Relatorio.ListReportLive do
  use PlataformaDigital, :auth_live_view

  #  alias ModuloPesquisa.Repository

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

    {:ok, assign(socket, relatorios: list)}
  end

  @impl true
  def handle_event("download_file", _session, socket) do
    {:ok, file_path} = "relatorios.link"
    send_download_response(socket, file_path)
  end

  defp send_download_response(socket, file_path) do
    {:ok, file} = File.read(file_path)

    socket
    |> put_flash(:info, "Arquivo baixado com sucesso!!!")
    |> send(file: file, filename: File.basename(file_path))
  end
end
