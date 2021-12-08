defmodule FuschiaWeb.Swagger.Security do
  @moduledoc false

  @doc """
  Default security for public endpoints
  """
  @spec public :: list(map)
  def public do
    [
      %{"api_key_header" => []},
      %{"api_key_query" => []}
    ]
  end

  @doc """
  Default security for private endpoints
  """
  @spec private :: list(map)
  def private do
    [
      %{"authorization" => []},
      %{"api_key_header" => []},
      %{"api_key_query" => []}
    ]
  end
end
