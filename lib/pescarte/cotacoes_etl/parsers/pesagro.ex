defmodule Pescarte.CotacoesETL.Parsers.Pesagro do
  @behaviour Pescarte.CotacoesETL.Parser

  @pescado_header "Pescados"
  @csv_delimiter ";"
  @csv_headers ~w(pescado_codigo minima mais_comum maxima media min_max)

  @impl true
  def run(raw) do
    raw
    |> parse()
    |> dump_csv()
    |> to_csv_rows()
  end

  @impl true
  def parse(raw) do
    raw
    |> String.split("\n")
    |> extract_pescados_rows()
    |> String.split("\r")
    |> Enum.filter(&String.match?(&1, pescado_entry_regex()))
    |> Enum.map(&extract_pescado_fields/1)
  end

  defp extract_pescados_rows(data) do
    data
    |> Enum.chunk_by(&(&1 =~ @pescado_header))
    |> Enum.with_index()
    |> Enum.filter(fn {_, idx} -> idx in [2, 4] end)
    |> Enum.map_join(fn {x, _} -> x end)
  end

  defp extract_pescado_fields(data) do
    data
    |> format_pescado_fields()
    |> String.split(~r/\s/)
    |> split_pescado_codigo_and_values()
  end

  defp format_pescado_fields(data) do
    data
    |> String.replace(normalized_0_regex(), "0,00")
    |> String.trim()
    |> String.replace(~r/\s+/, " ")
    |> String.replace(",", ".")
  end

  defp split_pescado_codigo_and_values(data) do
    [pescado_codigo, values] =
      data
      |> Enum.map(&maybe_parse_float/1)
      |> Enum.chunk_by(&is_binary/1)

    {Enum.join(pescado_codigo, " "), values}
  end

  defp maybe_parse_float(str) do
    String.to_float(str)
  rescue
    _ -> str
  end

  @impl true
  def dump_csv(csv_content) do
    headers_str = Enum.join(@csv_headers, ";")

    csv_content
    |> Enum.map(fn {cod, values} -> Enum.join([cod | values], @csv_delimiter) end)
    |> List.insert_at(0, headers_str)
    |> Enum.join("\n")
  end

  @impl true
  def to_csv_rows(csv_content) do
    csv_content
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&parse_pescado_info/1)
  end

  @spec parse_pescado_info(binary) :: map
  defp parse_pescado_info(pescado_line) do
    [pescado_codigo, minima, mais_comum, maxima, media, _min_max] =
      String.split(pescado_line, ";", trim: true)

    %{
      pescado_codigo: pescado_codigo,
      minima: float_str_to_integer(minima),
      mais_comum: float_str_to_integer(mais_comum),
      maxima: float_str_to_integer(maxima),
      media: float_str_to_integer(media)
    }
  end

  defp float_str_to_integer(str) do
    str
    |> maybe_parse_float()
    |> Kernel.*(100)
    |> ceil()
  rescue
    _ -> 0
  end

  defp pescado_entry_regex do
    ~r/(\s+)([A-Z]|(\s+)|[0-9]+)(\s+(\d+,\d+))+/
  end

  defp normalized_0_regex do
    ~r/(?<=\s)(\b0\b)((?=\s)|$)/
  end
end
