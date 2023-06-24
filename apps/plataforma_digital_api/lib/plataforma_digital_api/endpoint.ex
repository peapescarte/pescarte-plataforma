defmodule PlataformaDigitalAPI.Endpoint do
  use Phoenix.Endpoint, otp_app: :plataforma_digital_api

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Absinthe.Plug, schema: PlataformaDigitalAPI.Schema
end
