defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller

  alias NimbleCSV.RFC4180, as: CSV

  def show(conn, _params) do
    # Pega a URL do arquivo CSV no Supabase e faz o download
    file_content =
      "agenda.csv"
      |> Pescarte.Storage.get_appointments_data_file_url()  # A URL do arquivo CSV no Supabase
      |> handle_url()  # Extrai a URL do tuple {:ok, url}
      |> download_file()

    # Limpeza do BOM e do conteúdo do CSV
    cleaned_content = clean_bom(file_content)

    current_month =
      cleaned_content
      |> CSV.parse_string(skip_headers: false)  # Parse do CSV sem o BOM
      |> Enum.take(1)
      |> List.first()

    table_data =
      cleaned_content
      |> CSV.parse_string()
      |> Stream.drop(1)  # Remove o cabeçalho
      |> Stream.filter(&valid_row?/1)
      |> Stream.map(&convert_to_map/1)
      |> then(fn rows ->
        total_rows = Enum.count(rows)

        rows
        |> Enum.chunk_every(total_rows)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {lista, index}, acc -> Map.put(acc, index, lista) end)
      end)

    current_path = conn.request_path

    render(conn, :show,
      mapa: table_data,
      current_month: current_month,
      current_path: current_path
    )
  end

  defp handle_url({:ok, url}), do: url  # Função para extrair a URL de um tuple {:ok, "url"}
  defp handle_url({:error, _reason}), do: nil  # Em caso de erro, você pode lidar de acordo com a necessidade

  defp download_file(nil), do: {:error, :file_not_found}  # Caso a URL seja nil
  defp download_file(url) do
    {:ok, %{body: body}} = HTTPoison.get(url)
    body
  end

  defp clean_bom(content) do
    String.replace(content, "\uFEFF", "")  # Remove o BOM, se houver
  end

  defp convert_to_map([data, horario, atividade, local]) do
    %{
      data: data,
      horario: horario,
      atividade: atividade,
      local: local
    }
  end

  defp valid_row?(row) do
    Enum.all?(row, fn field -> String.trim(field) != "" end)
  end
end
