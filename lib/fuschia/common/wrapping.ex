defmodule Fuschia.Common.Wrapping do
  @moduledoc """
  This module is used to handle wrapping on pipelines
  """

  @spec ok_unwrap({:ok, any}) :: any
  def ok_unwrap({:ok, result}), do: result

  @spec ok_wrap(any) :: {:ok, any}
  def ok_wrap(result), do: {:ok, result}

  @spec error_wrap(any) :: {:error, any}
  def error_wrap(error), do: {:error, error}
end
