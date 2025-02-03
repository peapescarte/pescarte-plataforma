defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller

  alias NimbleCSV.RFC4180, as: CSV

  def show(conn, _params) do
    current_month =
      "appointments_data"
      |> Pescarte.get_static_file_path("agenda_fevereiro.csv")
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.take(1)
      |> List.first()

    table_data =
      "appointments_data"
      |> Pescarte.get_static_file_path("agenda_fevereiro.csv")
      |> File.stream!()
      |> CSV.parse_stream()
      |> Stream.drop(1)
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
