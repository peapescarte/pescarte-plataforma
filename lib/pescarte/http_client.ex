defmodule Backend.HttpClient do
  @moduledoc """
  Implementação de um HTTP Client a partir de um HttpClient.Behaviour
  que define informações básicas sobre uma conexão com
  """

  alias HttpClientBehaviour

  @doc """
  Cria um cliente para ser utilizado em requests futuros
  """
  @spec build(HttpClientBehaviour.t()) :: Tesla.Client.t()
  def build(impl) do
    middleware =
      [
        {Tesla.Middleware.BaseUrl, impl.base_url()},
        Tesla.Middleware.KeepRequest,
        Tesla.Middleware.JSON
      ] ++ impl.headers()

    Tesla.client(middleware)
  end

  @spec post(Tesla.Client.t(), Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.result()
  defdelegate post(client, url, body), to: Tesla

  @spec post!(Tesla.Client.t(), Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.t() | no_return()
  defdelegate post!(client, url, body), to: Tesla

  @spec get(Tesla.Client.t(), Tesla.Env.url()) :: Tesla.Env.result()
  defdelegate get(client, url), to: Tesla

  @spec get!(Tesla.Client.t(), Tesla.Env.url()) :: Tesla.Env.t() | no_return()
  defdelegate get!(client, url), to: Tesla

  @spec put(Tesla.Client.t(), Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.result()
  defdelegate put(client, url, body), to: Tesla

  @spec put!(Tesla.Client.t(), Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.t() | no_return()
  defdelegate put!(client, url, body), to: Tesla

  @spec delete(Tesla.Client.t(), Tesla.Env.url(), Tesla.Env.body()) :: Tesla.Env.result()
  defdelegate delete(client, url, body), to: Tesla

  @spec delete!(Tesla.Client.t(), Tesla.Env.url()) :: Tesla.Env.t() | no_return()
  defdelegate delete!(client, url), to: Tesla
end
