defmodule Pescarte.Encoder do
  @moduledoc """
  Pescarte Custom JSON Encoder
  """

  @spec encode(map, any) :: map
  def encode(attrs, opts) do
    attrs
    |> remove_not_loaded()
    # |> ProperCase.to_camel_case()
    |> Jason.Encode.map(opts)
  end

  @spec remove_not_loaded(map) :: map
  def remove_not_loaded(attrs) do
    not_loaded = Enum.filter(attrs, &not_loaded?/1)

    Map.drop(attrs, Keyword.keys(not_loaded))
  end

  defp not_loaded?({_, value}),
    do: match?(%Ecto.Association.NotLoaded{}, value)
end
