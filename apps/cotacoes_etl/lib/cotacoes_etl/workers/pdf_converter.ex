defmodule CotacoesETL.Workers.PDFConverter do
  @moduledoc """
  Este worker é responsável por converter arquivos PDF para
  outros formatos, primordialmente para TXT. Para isso é usado
  o programa `ghostscript`. Assim que a conversão é finalizada,
  uma mensagem é devolvida para o PID que iniciou esse worker,
  avisando que o PDF foi extraído.
  """

  use GenServer

  import CotacoesETL.Handlers, only: [pdf_converter_handler: 0]

  alias CotacoesETL.Events.ConvertPDFEvent
  alias CotacoesETL.Events.PDFConvertedEvent

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:convert, %ConvertPDFEvent{} = event}, state) do
    txt_content = pdf_converter_handler().convert_to_txt!(event.pdf_path)

    unless File.exists?(event.destination_path) do
      File.mkdir_p!(event.destination_path)
    end

    file_path = Path.join(event.destination_path, mk_file_name(event.pdf_path))
    File.write!(file_path, txt_content)

    payload = PDFConvertedEvent.new(%{file_path: file_path, cotacao: event.cotacao})
    Process.send(event.issuer, {:pdf_converted, payload}, [])

    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    GenServer.cast(__MODULE__, msg)
    {:noreply, state}
  end

  defp mk_file_name(current) do
    current
    |> String.split("/")
    |> List.last()
    |> String.replace("pdf", "txt")
  end
end
