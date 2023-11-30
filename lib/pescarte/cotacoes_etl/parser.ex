defmodule Pescarte.CotacoesETL.Parser do
  @typep csv_content :: list(binary)

  @callback run(binary) :: list(map)
  @callback parse(binary) :: list(term)
  @callback dump_csv(csv_content) :: binary
  @callback to_csv_rows(binary) :: list(map)
end
