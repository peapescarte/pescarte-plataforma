defmodule ProxyWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :proxy_web

  plug ProxyWeb.Router, %{
    api: PlataformaDigitalAPI.Endpoint,
    default: PlataformaDigital.Endpoint
  }
end
