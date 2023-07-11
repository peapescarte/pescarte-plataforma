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

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:convert, caller: caller, from: file_path, to: dest_path, format: :txt}, state) do
    Logger.info("[#{__MODULE__}] ==> Convertendo arquivo #{file_path} para TXT")

    txt_content = pdf_converter_handler().convert_to_txt!(file_path)

    unless File.exists?(dest_path) do
      File.mkdir_p!(dest_path)
    end

    file_path = Path.join(dest_path, mk_file_name(file_path))
    File.write!(file_path, txt_content)
    Logger.info("[#{__MODULE__}] ==> Arquivo #{file_path} criado")

    Process.send(caller, {:pdf_converted, file_path}, [])

    {:noreply, state}
  end

  defp mk_file_name(current) do
    current
    |> String.split("/")
    |> List.last()
    |> String.replace("pdf", "txt")
  end
end
