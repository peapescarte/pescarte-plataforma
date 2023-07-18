defmodule CotacoesETL.Parsers.Pesagro do
  @behaviour CotacoesETL.Parser

  import Explorer.Series, only: [multiply: 2, cast: 2]

  alias Explorer.DataFrame

  @pescado_header "Pescados"
  @pescado_entry_regex ~r/(\s+)([A-Z]|(\s+)|[0-9]+)(\s+(\d+,\d+))+/
  @normalized_0_regex ~r/(?<=\s)(\b0\b)((?=\s)|$)/
  @csv_delimiter ";"
  @csv_headers ~w(pescado_codigo minima mais_comum maxima media min_max)
  @dataframe_columns ~w(pescado_codigo minima mais_comum maxima media)
  @dataframe_types %{
    "pescado_codigo" => :string,
    "minima" => :float,
    "mais_comum" => :float,
    "maxima" => :float,
    "media" => :float
  }

  @impl true
  def parse(raw) do
    raw
    |> String.split("\n")
    |> extract_pescados_rows()
    |> String.split("\r")
    |> Enum.filter(&String.match?(&1, @pescado_entry_regex))
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
    |> String.replace(@normalized_0_regex, "0,00")
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
  def to_dataframe(raw) do
    opts = [delimiter: @csv_delimiter, dtypes: @dataframe_types, columns: @dataframe_columns]

    raw
    |> parse()
    |> dump_csv()
    |> Explorer.DataFrame.load_csv(opts)
    |> case do
      {:ok, df} ->
        require Explorer.DataFrame

        {:ok,
         df
         |> DataFrame.mutate(minima: cast(multiply(minima, 100), :integer))
         |> DataFrame.mutate(mais_comum: cast(multiply(mais_comum, 100), :integer))
         |> DataFrame.mutate(maxima: cast(multiply(maxima, 100), :integer))
         |> DataFrame.mutate(media: cast(multiply(media, 100), :integer))}

      err ->
        err
    end
  end

  @spec get_pesagro_rows(DataFrame.t()) :: list(map)
  def get_pesagro_rows(df) do
    DataFrame.to_rows(df, atom_keys: true)
  end
end
