defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller
  alias NimbleCSV.RFC4180, as: CSV

  def show(conn, _params) do
    case Pescarte.Storage.fetch_appointments_csv("agenda.csv") do
      {:ok, file_content} ->
        {rows, month} = parse_appointments_csv(file_content)

        render(conn, :show,
          rows: rows,
          month: month,
          current_path: conn.request_path
        )

      {:error, reason} ->
        conn
        |> put_flash(:error, "Não foi possível carregar a agenda (#{inspect(reason)}).")
        |> redirect(to: "/")
    end
  end

  defp parse_appointments_csv(file_content) do
    cleaned_content = clean_bom(file_content)

    [month_line | csv_lines] =
      cleaned_content
      |> String.trim_trailing()
      |> String.split("\n")

    rows =
      csv_lines
      |> Enum.join("\n")
      |> CSV.parse_string(skip_headers: true)
      |> Enum.filter(&valid_row?/1)
      |> Enum.map(&convert_to_map/1)

    {rows, String.trim(month_line)}
  end

  defp clean_bom(<<"\uFEFF", rest::binary>>), do: rest
  defp clean_bom(content), do: content

  defp convert_to_map([data, horario, atividade, local]) do
    %{
      data: String.trim(data),
      horario: String.trim(horario),
      atividade: String.trim(atividade),
      local: String.trim(local)
    }
  end

  defp valid_row?(row), do: Enum.all?(row, &(String.trim(&1) != ""))
end
