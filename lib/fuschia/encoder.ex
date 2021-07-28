defmodule Fuschia.Encoder do
  @moduledoc """
  Fuschia Custom JSON Encoder
  """

  def encode(attrs, opts) do
    attrs
    |> remove_not_loaded()
    |> ProperCase.to_camel_case()
    |> Jason.Encode.map(opts)
  end

  def remove_not_loaded(attrs) do
    not_loaded =
      attrs
      |> Enum.filter(&not_loaded?/1)

    Map.drop(attrs, Keyword.keys(not_loaded))
  end

  defp not_loaded?({_, value}),
    do: match?(%Ecto.Association.NotLoaded{}, value)
end
