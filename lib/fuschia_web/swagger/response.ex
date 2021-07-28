defmodule FuschiaWeb.Swagger.Response do
  @moduledoc false

  alias FuschiaWeb.Swagger.Error

  @type response_error :: Error.GenericError | Error.Unauthorized

  @spec errors(list) :: [{atom, String.t(), response_error()}]
  def errors(options) when is_list(options) do
    Enum.map(options, &get_error/1)
  end

  @spec errors(atom) :: [{atom, String.t(), response_error()}]
  def errors(key) do
    [get_error(key)]
  end

  defp get_error(key) do
    errors = %{
      not_found: {"Not found, inexistent ID", "application/json", Error.GenericError},
      unauthorized:
        {"Unauthorized access. Invalid/missing API key or JWT token", "application/json",
         Error.Unauthorized},
      forbidden: {"Access Denied", "application/json", Error.Forbidden}
    }

    {key, Map.get(errors, key)}
  end
end
