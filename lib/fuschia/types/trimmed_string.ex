defmodule Fuschia.Types.TrimmedString do
  @moduledoc """
  Provides a trimmed String Type
  """

  @behaviour Ecto.Type

  @spec type :: :string
  def type, do: :string

  @spec cast(any) :: {:ok, any} | {:error, keyword}
  def cast(binary) when is_binary(binary), do: {:ok, String.trim(binary)}
  def cast(other), do: Ecto.Type.cast(:string, other)

  @spec load(any) :: {:ok, any} | :error
  def load(data), do: Ecto.Type.load(:string, data)

  @spec dump(any) :: {:ok, any} | :error
  def dump(data), do: Ecto.Type.dump(:string, data)

  @spec equal?(String.t() | nil, String.t() | nil) :: bool
  def equal?(x, y) when is_nil(x) and is_binary(y), do: false
  def equal?(x, y) when is_binary(x) and is_nil(y), do: false
  def equal?(x, y), do: x == y

  @spec embed_as(any) :: :self
  def embed_as(_format), do: :self
end
