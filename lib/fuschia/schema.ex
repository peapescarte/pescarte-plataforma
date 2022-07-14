defmodule Fuschia.Schema do
  @moduledoc """
  Default schema for Fuschia
  """

  @doc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end
end
