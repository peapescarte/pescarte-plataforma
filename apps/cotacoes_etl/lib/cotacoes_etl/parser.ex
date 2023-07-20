defmodule CotacoesETL.Parser do
  @typep csv_content :: list(binary)

  @callback parse(binary) :: list(term)
  @callback dump_csv(csv_content) :: binary
  @callback to_dataframe(binary) :: {:ok, Explorer.DataFrame.t()} | {:error, term}
end
