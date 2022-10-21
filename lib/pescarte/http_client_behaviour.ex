defmodule Backend.HttpClientBehaviour do
  @moduledoc """
  Behaviour para comunicação HTTP, define argumentos necessários para realizar uma requisição
  """

  @callback base_url() :: binary

  @callback headers() :: [{binary, binary}]
end
