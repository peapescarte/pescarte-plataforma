defmodule Fuschia.Repo do
  use Ecto.Repo,
    otp_app: :fuschia,
    adapter: Ecto.Adapters.Postgres
end
