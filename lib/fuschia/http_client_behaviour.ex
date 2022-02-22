defmodule Fuschia.HttpClientBehaviour do
  @moduledoc """
  Behaviour para comunicação HTTP, define argumentos necessários para realizar uma requisição
  """

  @callback base_url() :: String.t()

  @callback headers() :: [{binary, binary}]
end
