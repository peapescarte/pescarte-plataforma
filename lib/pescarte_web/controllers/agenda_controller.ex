defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller

  alias NimbleCSV.RFC4180, as: CSV

  def show(conn, _params) do
    with {:ok, file_content} <- Pescarte.Storage.fetch_appointments_csv("agenda.csv") do
      cleaned_content = clean_bom(file_content)

      [current_month | rest] =
        cleaned_content
        |> CSV.parse_string(skip_headers: false)

      [_header | data_rows] = rest

      rows =
        data_rows
        |> Enum.filter(&valid_row?/1)
        |> Enum.map(&convert_to_map/1)

      render(conn, :show,
        rows: rows,
        current_month: List.first(current_month),
        current_path: conn.request_path
      )
    else
      {:error, reason} ->
        conn
        |> put_flash(:error, "Não foi possível carregar a agenda (#{inspect(reason)}).")
        |> redirect(to: "/")
    end
  end

  defp clean_bom(<< "\uFEFF", rest::binary >>), do: rest
  defp clean_bom(content),                     do: content

  defp convert_to_map([data, horario, atividade, local]) do
    %{
      data:      String.trim(data),
      horario:   String.trim(horario),
      atividade: String.trim(atividade),
      local:     String.trim(local)
    }
  end

  defp valid_row?(row), do: Enum.all?(row, &(String.trim(&1) != ""))
end
