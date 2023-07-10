defmodule CotacoesETL.Workers.PDFConverter do
  @moduledoc """
  Este worker é responsável por converter arquivos PDF para
  outros formatos, primordialmente para TXT. Para isso é usado
  o programa `ghostscript`. Assim que a conversão é finalizada,
  uma mensagem é devolvida para o PID que iniciou esse worker,
  avisando que o PDF foi extraído.
  """

  use GenServer

  require Logger

  # requires ghostscript to be installed first - on mac, install with `brew install ghostscript`
  # -sDEVICE=txtwrite   - text writer
  # -sOutputFile=-      - use stdout instead of a file
  # -q                  - quiet - prevent writing normal messages to output
  # -dNOPAUSE           - disable prompt and pause at end of each page
  # -dBATCH             - indicates batch operation so exits at end of processing
  @ghostscript_args ~w(-sDEVICE=txtwrite -sOutputFile=- -q -dNOPAUSE -dBATCH)
  defp mk_ghostscript_args(input_file) do
    List.insert_at(@ghostscript_args, -1, input_file)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def convert_pdf_to_txt(file_path, dest_path, caller) do
    GenServer.cast(
      __MODULE__,
      {:convert, caller: caller, from: file_path, to: dest_path, format: :txt}
    )
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:convert, caller: caller, from: file_path, to: dest_path, format: :txt}, state) do
    Logger.info("[#{__MODULE__}] ==> Convertendo arquivo #{file_path} para TXT")

    {txt_content, 0} = System.cmd("gs", mk_ghostscript_args(file_path))

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
