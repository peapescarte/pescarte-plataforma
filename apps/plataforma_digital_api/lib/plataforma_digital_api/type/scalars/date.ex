defmodule PlataformaDigitalAPI.Type.Scalars.Date do
  use Absinthe.Schema.Notation

  @desc "Tipo que representa uma data ISO8601"
  scalar :date, name: "Date" do
    serialize(&Date.to_iso8601/1)
    parse(&parse_date/1)
  end

  defp parse_date(%Absinthe.Blueprint.Input.String{value: value}) do
    case Date.from_iso8601(value) do
      {:ok, date} -> {:ok, date}
      _error -> :error
    end
  end

  defp parse_date(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp parse_date(_), do: :error
end
