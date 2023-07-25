defmodule PlataformaDigital.Endpoint do
  use Phoenix.Endpoint, otp_app: :plataforma_digital

  plug PlataformaDigital.HealthCheck

  @session_options [
    store: :cookie,
    key: "_pescarte_key",
    signing_salt: "7ZI1IH1h"
  ]

  socket "/socket", PlataformaDigital.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :plataforma_digital,
    gzip: true,
    only: PlataformaDigital.static_paths()

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options

  plug PlataformaDigital.Router
end
