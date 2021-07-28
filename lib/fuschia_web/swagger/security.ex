defmodule FuschiaWeb.Swagger.Security do
  @moduledoc false

  @doc """
  Default security for public endpoints
  """
  def public do
    [
      %{"api_key_header" => []},
      %{"api_key_query" => []}
    ]
  end

  @doc """
  Default security for private endpoints
  """
  def private do
    [
      %{"authorization" => []},
      %{"api_key_header" => []},
      %{"api_key_query" => []}
    ]
  end
end
