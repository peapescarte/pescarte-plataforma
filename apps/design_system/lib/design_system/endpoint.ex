defmodule DesignSystem.Endpoint do
  use Phoenix.Endpoint, otp_app: :design_system

  plug Plug.Static,
    at: "/design-system",
    from: :design_system,
    gzip: true,
    only: ~w(pescarte.min.css storybook.css storybook.js)

  plug Plug.Session,
    store: :cookie,
    key: "_design_system_key",
    signing_salt: "OBcQb8Zm"

  plug DesignSystem.Router
end
