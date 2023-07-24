defmodule ProxyWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :proxy_web

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :database
  end

  plug ProxyWeb.Router, %{
    api: PlataformaDigitalAPI.Endpoint,
    default: PlataformaDigital.Endpoint
  }
end
