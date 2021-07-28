defmodule Fuschia.Types.UpcaseString do
  @moduledoc """
  Provides a upcased String Type
  """

  @behaviour Ecto.Type

  def type, do: :string

  def cast(binary) when is_binary(binary) do
    {:ok,
     binary
     |> String.trim()
     |> String.upcase()}
  end

  def cast(other), do: Ecto.Type.cast(:string, other)

  def load(data), do: Ecto.Type.load(:string, data)

  def dump(data), do: Ecto.Type.dump(:string, data)

  def equal?(x, y) when is_nil(x) and is_binary(y), do: false
  def equal?(x, y) when is_binary(x) and is_nil(y), do: false
  def equal?(x, y), do: x == y

  def embed_as(_format), do: :self
end
