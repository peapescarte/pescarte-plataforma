defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller

  alias NimbleCSV.RFC4180, as: CSV

  def show(conn, _params) do
    table_data =
      "appointments_data"
      |> Pescarte.get_static_file_path("compromissos.csv")
      |> File.stream!()
      |> CSV.parse_stream()
      |> Stream.map(&convert_to_map/1)
      |> Enum.filter(& &1)
      |> Enum.chunk_every(4)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {lista, index}, acc -> Map.put(acc, index, lista) end)

    current_path = conn.request_path

    render(conn, :show, mapa: table_data, current_path: current_path)
  end

  defp convert_to_map([meta, data, horario, duracao, atividade, local, participantes]) do
    %{
      meta: meta,
      data: data,
      horario: horario,
      duracao: duracao,
      atividade: atividade,
      local: local,
      participantes: participantes
    }
  end
end
